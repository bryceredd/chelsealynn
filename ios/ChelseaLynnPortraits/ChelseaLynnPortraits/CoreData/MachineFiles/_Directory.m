// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Directory.m instead.

#import "_Directory.h"

const struct DirectoryAttributes DirectoryAttributes = {
	.name = @"name",
};

const struct DirectoryRelationships DirectoryRelationships = {
	.images = @"images",
};

const struct DirectoryFetchedProperties DirectoryFetchedProperties = {
};

@implementation DirectoryID
@end

@implementation _Directory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Directory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Directory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Directory" inManagedObjectContext:moc_];
}

- (DirectoryID*)objectID {
	return (DirectoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic images;

	
- (NSMutableOrderedSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	






@end
