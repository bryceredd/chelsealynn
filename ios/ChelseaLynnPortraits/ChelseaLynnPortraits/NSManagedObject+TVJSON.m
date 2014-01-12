//
// NSManagedObject+JSON.m
//
// Created by Bryce Redd on 4/25/12.
// Copyright (c) 2012 Itv. All rights reserved.
//

#import "NSManagedObject+TVJSON.h"
#import "ISO8601DateFormatter.h"
#import "NSObject+TVProperties.h"
#import "NSArray+ConciseKit.h"
#import "DDPersist.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation NSManagedObject (TVJSON)

+ (id) objectWithObject:(id)arrayOrDictionary {
    return [self objectWithObject:arrayOrDictionary inContext:[DDPersist mainContext] upsert:YES];
}

+ (id) objectWithObject:(id)arrayOrDictionary upsert:(BOOL)upsert {
    return [self objectWithObject:arrayOrDictionary inContext:[DDPersist mainContext] upsert:upsert];
}

+ (id) objectWithObject:(id)arrayOrDictionary inContext:(NSManagedObjectContext*)context {
    return [self objectWithObject:arrayOrDictionary inContext:context upsert:YES];
}

+ (id) objectWithObject:(id)arrayOrDictionaryOrStringkey inContext:(NSManagedObjectContext*)context upsert:(BOOL)upsert {
    
    if([arrayOrDictionaryOrStringkey isKindOfClass:[NSDictionary class]]) {
        return [self objectWithDefinition:arrayOrDictionaryOrStringkey context:context upsert:upsert];
    }
    
    if([arrayOrDictionaryOrStringkey isKindOfClass:[NSArray class]]) {
        return [self objectsWithArray:arrayOrDictionaryOrStringkey context:context upsert:upsert];
    }
    
    if([arrayOrDictionaryOrStringkey isKindOfClass:[NSString class]]) {
        return [self objectWithUniqueKey:arrayOrDictionaryOrStringkey context:context upsert:upsert];
    }
    
    NSLog(@"Something went wrong! JSON parse should only accept an array, dictionary, or string but was passed: %@", arrayOrDictionaryOrStringkey);
    
    return nil;
}

+ (id) objectWithDefinition:(NSDictionary*)definition context:(NSManagedObjectContext*)context upsert:(BOOL)upsert {
    
    if (![self conformsToProtocol:@protocol(TVJSONManagedObject)]) {
        NSLog(@"NSManagedObject+JSON objects requires the UpdateObject protocol.");
        NSAssert(false, @"");
        return nil;
    }
    
    if (![self respondsToSelector:@selector(uniqueIdKey)] && upsert) {
        NSLog(@"NSManagedObject+JSON must implement uniqueIdKey if upsert = true!");
        NSAssert(false, @"");
        return nil;
    }
    
    NSManagedObject<TVJSONManagedObject>* object = nil;
    Class klass = [self classForDocument:definition];
    
    
    if(upsert) {
        NSPredicate* predicate = [(id)klass predicateForDefinition:definition];
        object = [context fetchOrInsertEntity:klass withPredicate:predicate];
//        object = [(id)klass fetchOrInsertSingleWithPredicate:predicate];  //  remove
    } else {
        object = [context insertEntityFromClass:klass];
//         [(id)klass insert];  //  remove
    }
    
    [(id)klass hydratePropertiesOnObject:object definition:definition upsert:upsert];
    [(id)klass hydrateRelationshipsOnObject:object definition:definition upsert:upsert];
    [(id)klass hydrateNonCoreDataPropertiesOnObject:object definition:definition upsert:upsert];
    
    return object;
}

+ (id) objectsWithArray:(NSArray*)array context:(NSManagedObjectContext*)context upsert:(BOOL)upsert {
    int OPTIMIZE_LOOKUP_THRESHOLD = 5;
    
    // this optimization has two branches.  the first is a flat upsert
    // calling a lookup for each incoming object.
    
    if([array count] < OPTIMIZE_LOOKUP_THRESHOLD || !upsert) {
        return [array $map:^(NSDictionary* definition) {
            
            // occasionally only an array of identifiers is sent.  in this case
            // we will assume these are primary keys and need to be upserted
            
            return [self objectWithObject:definition inContext:context upsert:upsert];
        }];
    }
    
    
    
    // the second type of update will do a large batch call fetching
    // all the data objects in memory, then sorting and walking the
    // both arrays looking to match objects
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    NSString *jsonIdKey = [self uniqueIdKeyForDefinition:array[0]];
    
    NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    request.predicate = [self predicateForDefinitions:array];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:uniqueIdKey ascending:YES]];
    
    // it important we remember the original order of the json objects
    NSMutableDictionary* order = [@{} mutableCopy];
    for(int i=0; i<array.count; i++) {
        NSDictionary* def = array[i];
        NSString* key = (id)def;
        if([def isKindOfClass:[NSDictionary class]])
            key = def[jsonIdKey];
        order[key] = @(i);
    }
    
    NSError* error;
    NSArray* existingObjects = [context executeFetchRequest:request error:&error];
    NSArray* jsonObjects = [array sortedArrayUsingComparator:^(NSDictionary* def1, NSDictionary* def2) {
        if([def1 isKindOfClass:[NSString class]]) {
            return [(NSString*)def1 compare:(NSString*)def2];
        }
        
        return [def1[jsonIdKey] compare:def2[jsonIdKey]];
    }];
    
    
    NSMutableArray* objects = [NSMutableArray array];
    
    int existingObjectsIndex = 0;
    for(int i=0; i<jsonObjects.count; i++) {
        
        NSDictionary* definition = jsonObjects[i];
        NSString* jsonUniqueId = [self uniqueIdForDefinition:definition];
        
        
        NSString* existingUniqueId = nil;
        id existingObject = nil;
        while(existingObjectsIndex < existingObjects.count) {
            existingObject = existingObjects[existingObjectsIndex];
            existingUniqueId = [existingObject valueForKey:uniqueIdKey];
            
            if([existingUniqueId compare:jsonUniqueId] == NSOrderedAscending)
                existingObjectsIndex++;
            else
                break;
        }
        
        Class klass = [self classForDocument:definition];
        
        id object = nil;
        if (jsonUniqueId && existingUniqueId && [jsonUniqueId compare:existingUniqueId] == NSOrderedSame)
            object = existingObject;
        else
            object = [context insertEntityFromClass:klass];
//            object = [(id)klass insert];  //  remove
        
        if([definition isKindOfClass:[NSString class]]) {
            [object setValue:definition forKey:uniqueIdKey];
        } else {
            [(id)klass hydratePropertiesOnObject:object definition:definition upsert:upsert];
            [(id)klass hydrateRelationshipsOnObject:object definition:definition upsert:upsert];
            [(id)klass hydrateNonCoreDataPropertiesOnObject:object definition:definition upsert:upsert];
        }
        
        [objects addObject:object];
    }
    
    return [objects sortedArrayUsingComparator:^(id object1, id object2) {
        return [order[[object1 valueForKey:uniqueIdKey]] compare:order[[object2 valueForKey:uniqueIdKey]]];
    }];
}

+ (id) objectWithUniqueKey:(NSString*)key context:(NSManagedObjectContext*)context upsert:(BOOL)upsert {
    if (![self respondsToSelector:@selector(uniqueIdKey)]) {
        NSLog(@"NSManagedObject+JSON was passed an array of ids with no uniqueIdKey specified! %@, %@", self, key);
        NSAssert(false, @"");
        return nil;
    }
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    NSString *halfPredicate = [NSString stringWithFormat:@"%@=%%@", uniqueIdKey];
    Class klass = [self classForDocument:@{uniqueIdKey: key}];
    
    // this does not upsert, just find or create a new, blank object
//    id obj = [klass fetchOrInsertSingleWithPredicate:[NSPredicate predicateWithFormat:halfPredicate, key]];   //  remove
    id obj = [context fetchOrInsertEntity:klass withPredicate:[NSPredicate predicateWithFormat:halfPredicate, key]];
    
    // so we need to set the key
    [obj setValue:key forKey:uniqueIdKey];
    
    return obj;
}

+ (void) hydrateRelationshipsOnObject:(NSManagedObject*)object definition:(NSDictionary*)definition upsert:(BOOL)upsert {
    
    NSDictionary* relationships = [[object entity] relationshipsByName];
    
    for(NSString* JSONKey in definition) {
        NSString* key = [self keyForJSONKey:JSONKey];
        NSDictionary* childDefinition = definition[JSONKey];
        NSRelationshipDescription* relationshipDescription = relationships[key];
        
        if(!relationshipDescription) continue;
        if(!childDefinition || [childDefinition isKindOfClass:[NSNull class]]) continue;
        
        BOOL isToMany = [relationshipDescription isToMany];
        Class relationshipClass = NSClassFromString([[relationshipDescription destinationEntity] managedObjectClassName]);
        id child = [relationshipClass objectWithObject:childDefinition inContext:object.managedObjectContext upsert:upsert];
        
        if(!upsert) {
            if([child isKindOfClass:[NSArray class]]) { child = [NSSet setWithArray:child]; }
            [object setValue:child forKey:key];
            continue;
        }
        
        else if(upsert && !isToMany) {
            
            BOOL isDifferentObject = ![[object valueForKey:key] isEqual:child];
            if(isDifferentObject) { [object setValue:child forKey:key]; }
            
        } else {
            
            // if we're upserting the relationship we have to add
            // the new objects, and remove the old.  the existing
            // ones have been updated
            
            SEL addObjectSelector = [self addSelectorForRelationship:key];
            SEL removeObjectsSelector = [self removeSelectorForRelationship:key];
            
            NSMutableSet* addedObjects = [NSMutableSet set];
            
            // for optimized goodness we'll make the relationship objects
            // in array form first
            
            for(NSManagedObject* childObject in child) {
                
                // add new objects that weren't there before
                if(![[object valueForKey:key] containsObject:childObject]) {
                    [object performSelector:addObjectSelector withObject:childObject];
                }
                
                // remember objects to not remove them
                [addedObjects addObject:childObject];
            }
            
            
            // remove any relationships that aren't in the
            // json dictionary - or in context, remove any
            // items that weren't in the 'addedObjects' set
            
            NSMutableSet* childrenToDelete = [[object valueForKey:key] mutableCopy];
            [childrenToDelete minusSet:addedObjects];
            
            if ([childrenToDelete count]) {
                [object performSelector:removeObjectsSelector withObject:childrenToDelete];
            }
        }
    }
}

+ (void) hydrateNonCoreDataPropertiesOnObject:(NSManagedObject<TVJSONManagedObject>*)object definition:(NSDictionary*)definition upsert:(BOOL)upsert {
    NSDictionary* attributes = [[object entity] attributesByName];
    NSDictionary* relationships = [[object entity] relationshipsByName];
    
    for(NSString* key in [object properties]) {
        NSString* JSONKey = [self keyForJSONKey:key];
        id value = definition[JSONKey];
        
        // make sure it's not a coredata attribute
        // or a coredata relationship
        if(attributes[key] || relationships[key]) continue;
        
        if(!key || !value || [value isKindOfClass:[NSNull class]]) continue;
        if([[object valueForKey:key] isEqual:value]) continue;
        
        [object setValue:value forKey:key];
    }
}

+ (void) hydratePropertiesOnObject:(NSManagedObject<TVJSONManagedObject>*)object definition:(NSDictionary*)definition upsert:(BOOL)upsert {
    
    NSDictionary* attributes = [[object entity] attributesByName];
    
    for(NSString* JSONKey in definition) {
        NSString* key = [self keyForJSONKey:JSONKey];
        id value = definition[JSONKey];
        NSAttributeDescription* attributeDescription = attributes[key];
        
        // set the attribute matches from the json
        if (attributeDescription) {
            
            if (attributeDescription) value = [self massagedValue:definition[JSONKey] forAttributeType:[attributeDescription attributeType]];
            
            // we won't overwrite attributes that are identical, if we do
            // then we throw an nsnotification saying an nsmanagedobject has
            // been updated, when it's really the same in every way
            if([[object valueForKey:key] isEqual:value]) continue;
            if(!key || !value || [value isKindOfClass:[NSNull class]]) continue;
            
            [object setValue:value forKey:key];
        }
    }
}

+ (id) massagedValue:(id)value forAttributeType:(NSAttributeType)attributeType {
    static ISO8601DateFormatter* formatter = nil;
    if(!formatter) formatter = [[ISO8601DateFormatter alloc] init];
    
    if(attributeType == NSStringAttributeType && [value isKindOfClass:[NSNumber class]]) {
        value = [value stringValue];
    } else if ((attributeType == NSInteger16AttributeType || attributeType == NSInteger32AttributeType || attributeType == NSInteger64AttributeType || attributeType == NSBooleanAttributeType) && [value isKindOfClass:[NSString class]]) {
        value = [NSNumber numberWithInt:[value intValue]];
    } else if (attributeType == NSFloatAttributeType && [value isKindOfClass:[NSString class]]) {
        value = [NSNumber numberWithFloat:[value floatValue]];
    } else if (attributeType == NSDateAttributeType && [value isKindOfClass:[NSString class]]) {
        value = [formatter dateFromString:value];
    } else if (attributeType == NSDoubleAttributeType && [value isKindOfClass:[NSString class]]) {
        value = [NSNumber numberWithDouble:[value doubleValue]];
    }
    
    return value;
}

+ (NSString*) keyForJSONKey:(NSString*)key {
    if ([self respondsToSelector:@selector(propertyOverrides)]) {
        NSString* overrideKey = [(id)self propertyOverrides][key];
        if(overrideKey) return overrideKey;
    }
    
    return key;
}

+ (Class) classForDocument:(NSDictionary*)definition {
    Class<TVJSONManagedObject> klass = [self respondsToSelector:@selector(classForUniqueDocument:)]? [(id)self classForUniqueDocument:definition] : self;
    return klass? klass : self;
}

+ (NSPredicate*) predicateForDefinition:(NSDictionary*)definition {
    if (![self respondsToSelector:@selector(uniqueIdKey)]) {
        NSLog(@"JSONBackedManagedObject objects must implement either uniqueIdKey or predicateForUniqueDocument:");
        NSAssert(false, @"");
        return nil;
    }
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    NSString *halfPredicate = [NSString stringWithFormat:@"%@=%%@", uniqueIdKey];
    NSString *uniqueId = [(id)self uniqueIdForDefinition:definition];
    
    return [NSPredicate predicateWithFormat:halfPredicate, uniqueId];
}

+ (NSPredicate*) predicateForDefinitions:(NSArray*)array {
    
    NSArray* identifiers = [array $map:^(NSDictionary* definition) {
        return [self uniqueIdForDefinition:definition];
    }];
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    NSString *halfPredicate = [NSString stringWithFormat:@"(%@ IN %%@)", uniqueIdKey];
    
    return [NSPredicate predicateWithFormat:halfPredicate, identifiers];
}

+ (NSString*) uniqueIdKeyForDefinition:(NSDictionary*)definition {
    
    // if the definition is actually a single key, we'll
    // just return the defined normal key
    
    if([definition isKindOfClass:[NSString class]]) {
        return [(id)self uniqueIdKey];
    }
    
    NSString *uniqueIdKey = [(id)self uniqueIdKey];
    
    if ([(id)self respondsToSelector:@selector(propertyOverrides)]) {
        NSDictionary *overrides = [(id)self propertyOverrides];
        if ([overrides allKeysForObject:uniqueIdKey]) {
            
            // try all the keys till we find one!
            for (NSString* potentialKey in [overrides allKeysForObject:uniqueIdKey]) {
                if(definition[potentialKey]) return potentialKey;
            }
        }
    }
    return uniqueIdKey;
}

+ (NSString*) uniqueIdForDefinition:(NSDictionary*)definition {
    if([definition isKindOfClass:[NSString class]]) return (NSString*)definition;
    
    NSString* uniqueId = definition[[self uniqueIdKeyForDefinition:definition]];
    if(!uniqueId) {
        NSLog(@"Expected an id for key:(%@) in definition:(%@) but found none", [self uniqueIdKeyForDefinition:definition], definition);
        NSAssert(0, @"Read error above");
    }
    return uniqueId;
}

+ (SEL) addSelectorForRelationship:(NSString*)key {
    NSString* uppercaseAttribute = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] capitalizedString]];
    return NSSelectorFromString([NSString stringWithFormat:@"add%@Object:", uppercaseAttribute]);
    
}

+ (SEL) removeSelectorForRelationship:(NSString*)key {
    NSString* uppercaseAttribute = [key stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[key substringToIndex:1] capitalizedString]];
    return NSSelectorFromString([NSString stringWithFormat:@"remove%@:", uppercaseAttribute]);
    
}

@end
