// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.m instead.

#import "_Image.h"

const struct ImageAttributes ImageAttributes = {
	.largeImageData = @"largeImageData",
	.name = @"name",
	.smallImageData = @"smallImageData",
};

const struct ImageRelationships ImageRelationships = {
	.directory = @"directory",
};

const struct ImageFetchedProperties ImageFetchedProperties = {
};

@implementation ImageID
@end

@implementation _Image

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Image";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Image" inManagedObjectContext:moc_];
}

- (ImageID*)objectID {
	return (ImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic largeImageData;






@dynamic name;






@dynamic smallImageData;






@dynamic directory;

	






@end
