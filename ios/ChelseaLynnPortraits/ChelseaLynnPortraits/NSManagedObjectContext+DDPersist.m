//  NSManagedObjectContext+DDPersistMoc.m
//  Created by ThD

#import "NSManagedObjectContext+DDPersist.h"



@interface DDPersist()
- (NSManagedObjectContext *)mainContextForCompare;
@end


@implementation NSManagedObjectContext (DDPersist)


#pragma mark - INSERT
- (id)insertEntityFromClass:(Class)klass {
    if(!klass) return nil;
    NSEntityDescription * newEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(klass) inManagedObjectContext:self];
    return newEntity;
}


#pragma mark - UNIQUENESS
- (BOOL)isEntityUnique:(NSString *)entityName attribute:(NSString *)attribute value:(id)value {
    NSError * error;
    NSFetchRequest * fr = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:entityName
                                                          inManagedObjectContext:self];
    [fr setEntity:entityDescription];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K == %@", attribute, value];
    [fr setPredicate:predicate];
    NSArray * results = [self executeFetchRequest:fr error:&error];
    return ([results count] <= 1);
}


#pragma mark - FETCH
- (id)fetchOneEntity:(Class)klass predicate:(NSPredicate*)predicate {
    if(predicate == nil) return nil;
    NSFetchRequest * fr = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:self];
    [fr setEntity:entityDescription];
    [fr setFetchLimit:1];
    [fr setPredicate:predicate];
    NSError * error;
    NSArray * result = [self executeFetchRequest:fr error:&error];
    if([result count])
        return [result objectAtIndex:0];
    return nil;
}

- (id)fetchOrInsertEntity:(Class)klass withPredicate:(NSPredicate*)predicate {
    if(predicate) {
        id obj = [self fetchOneEntity:klass predicate:predicate];
        if(obj) return obj;
    }
    //  insert!
    NSEntityDescription * newEntity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(klass) inManagedObjectContext:self];
    return newEntity;
}

- (id)fetchOneEntity:(Class)klass withPredicate:(NSPredicate*)predicate sortKey:(NSString*)sortKey ascending:(BOOL)ascending {
    NSAssert(klass, @"INVLAID CLASS!");
    if(!klass) return nil;
    NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:self];
    NSFetchRequest * fr = [[NSFetchRequest alloc] init];
    [fr setFetchLimit:1];
    [fr setEntity:entity];
    if(predicate) {
        [fr setPredicate:predicate];
    }
    if([sortKey length]) {
        NSSortDescriptor * sortD = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [fr setSortDescriptors:@[sortD]];
    }
    NSError * error;
    NSArray * result = [self executeFetchRequest:fr error:&error];
    if([result count] == 0) return nil;
    return [result objectAtIndex:0];
}

- (id)fetchEntities:(Class)klass withPredicate:(NSPredicate*)predicate sortKey:(NSString*)sortKey ascending:(BOOL)ascending {
    NSAssert(klass, @"INVLAID CLASS!");
    if(!klass) return nil;
    NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:self];
    NSFetchRequest * fr = [[NSFetchRequest alloc] init];
    [fr setEntity:entity];
    if(predicate) {
        [fr setPredicate:predicate];
    }
    if([sortKey length]) {
        NSSortDescriptor * sortD = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
        [fr setSortDescriptors:@[sortD]];
    }
    NSError * error;
    NSArray * result = [self executeFetchRequest:fr error:&error];
    if([result count] == 0) return nil;
    return result;
}


- (NSArray*)fetchEntities:(Class)klass predicate:(NSPredicate*)predicate {
    if(predicate == nil) return nil;
    NSFetchRequest * fr = [[NSFetchRequest alloc] init];
    NSEntityDescription * entityDescription = [NSEntityDescription entityForName:NSStringFromClass(klass) inManagedObjectContext:self];
    [fr setEntity:entityDescription];
    [fr setPredicate:predicate];
    NSError * error;
    NSArray * result = [self executeFetchRequest:fr error:&error];
    if([result count]) return result;
    return nil;
}

- (NSArray *)fetchEntitesWithName:(NSString *)entityName {
    return [self fetchEntitesWithName:entityName sortAttribute:nil ascending:NO moIdOnly:NO];
}

- (NSArray *)fetchEntitesWithName:(NSString *)entityName moIdOnly:(BOOL)moIdOnly {
    return [self fetchEntitesWithName:entityName sortAttribute:nil ascending:NO moIdOnly:moIdOnly];
}

- (NSArray *)fetchEntitesWithName:(NSString *)entityName sortAttribute:(NSString *)sortAttribute ascending:(BOOL)ascending moIdOnly:(BOOL)moIdOnly {
    NSAssert(entityName, @"Name for entity is not valid! Cannot fetch entities!!"); if([entityName length] == 0) return nil;
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSAssert(entity, @"No entity description named %@ exists!",entityName); if(!entity) return nil;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if(sortAttribute) {
        NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:sortAttribute ascending:ascending];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:descriptor]];
    }
    [fetchRequest setIncludesPropertyValues:!moIdOnly];
    NSError * fetchError;
    NSArray * results = [self executeFetchRequest:fetchRequest error:&fetchError];
    if([results count] == 0) return nil;
    return results;
}

- (NSArray *)fetchEntitiesWithName:(NSString *)entityName attribute:(NSString *)attribute value:(id)value {
    NSAssert(entityName,@"Name for entity is not valid! Cannot fetch entities!!");
    if([entityName length] == 0) return nil;
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSAssert(entity,@"The entity in %@ in storeContainsEntityNamed does not exists!",entityName);
    if(!entity) return nil;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    if(attribute && value) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"%K == %@",attribute,value];
        [fetchRequest setPredicate:filter];
    }
    NSError * fetchError;
    NSArray * results = [self executeFetchRequest:fetchRequest error:&fetchError];
    NSAssert(!fetchError,@"Error fetching entity %@! Error: %@", entityName, [fetchError userInfo]);
    if([results count] == 0 || fetchError) results = nil;
    return results;
}

- (NSManagedObject *)objectWithURI:(NSURL*)uri {
    NSAssert(uri, @"Invalid uri!!");
    if(!uri) return nil;
    NSManagedObjectID * objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:uri];
    if (!objectID) return nil;
    NSManagedObject * objectForID = [self objectWithID:objectID];
    if (![objectForID isFault]) return objectForID;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[objectID entity]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = %@", objectForID];
    [request setPredicate:predicate];
    NSArray *results = [self executeFetchRequest:request error:nil];
    
    if([results count] == 1) return [results lastObject];
    NSAssert([results count] == 0, @"FOUND MORE THAN ONE MANAGED OBJECT TO MATCH URI <%@>!! SHOULD NOT HAPPEN! FIX!", uri);
    return nil;
}


#pragma mark - COUNT
- (NSInteger)countForEntity:(NSString *)entityName {
    return [[self fetchEntitesWithName:entityName moIdOnly:YES] count];
}

- (NSInteger)countForEntity:(NSString *)entityName attribute:(NSString *)attribute value:(id)value {
    return [[self fetchEntitiesWithName:entityName attribute:attribute value:value] count];
}

- (NSUInteger)countEntities:(NSString *)name {
    return [self countEntities:name withAttribute:nil value:nil];
}

- (NSUInteger)countEntities:(NSString *)name withAttribute:(NSString *)attribute value:(id)value {
    
    NSFetchRequest * fr = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:name inManagedObjectContext:self];
    [fr setEntity:entity];
    [fr setIncludesSubentities:NO];
    [fr setIncludesPropertyValues:NO];
    
    if(attribute && value) {
        NSPredicate* pred = [NSPredicate predicateWithFormat:@"%K == %@", attribute, value];
        [fr setPredicate:pred];
    }
    
    NSError* error;
    NSUInteger count = 0;
    count = [self countForFetchRequest:fr error:&error];
    NSAssert(!error, @"Could not get count for <%@> entities! Error: %@",name, [error userInfo]);
    
    return count;
}

#pragma mark - PERSIST
- (BOOL)persist {
    if(DDPersistDebugLog) {
        if([DDPersist isMainContext:self]) {
            NSAssert([NSThread isMainThread], @"CALLING PERSIST ON MAIN CONTEXT NOT FROM MAIN THREAD!!!");
        }
    }
    NSError * error;
    if(![self save:&error]) {
        if(DDPersistDebugLog) {
            NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
            if(detailedErrors != nil && [detailedErrors count] > 0)
                for(NSError * detailedError in detailedErrors) NSLog(@"DetailedError: %@", [detailedError userInfo]);
            else
                NSLog(@"  %@", [error userInfo]);
            NSAssert(0, @"UNABLE TO SAVE CONTEXT");
        }
        return NO;
    }
    return YES;
}


#pragma mark - DELETION
- (BOOL)deleteEntitiesWithName:(NSString *)entityName {
    return [self deleteEntitiesWithName:entityName persist:NO];
}

- (BOOL)deleteEntitiesWithName:(NSString *)entityName persist:(BOOL)persist {
    NSArray * entities = [self fetchEntitesWithName:entityName moIdOnly:YES];
    if(entities == nil) return YES;
    if([entities count] == 0) return YES;
    for(NSManagedObject* mo in entities)
        if(mo) [self deleteObject:mo];
    
    if(!persist) return YES;
    BOOL deleted = [self persist];
    if(deleted) return YES;
    NSAssert(0,@"Unable to delete entities named: <%@>", entityName);
    return NO;
}




@end
