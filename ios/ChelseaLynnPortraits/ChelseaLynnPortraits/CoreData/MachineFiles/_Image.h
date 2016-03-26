// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Image.h instead.

#import <CoreData/CoreData.h>


extern const struct ImageAttributes {
	__unsafe_unretained NSString *largeImageData;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *smallImageData;
} ImageAttributes;

extern const struct ImageRelationships {
	__unsafe_unretained NSString *directory;
} ImageRelationships;

extern const struct ImageFetchedProperties {
} ImageFetchedProperties;

@class Directory;





@interface ImageID : NSManagedObjectID {}
@end

@interface _Image : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ImageID*)objectID;





@property (nonatomic, strong) NSData* largeImageData;



//- (BOOL)validateLargeImageData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* smallImageData;



//- (BOOL)validateSmallImageData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Directory *directory;

//- (BOOL)validateDirectory:(id*)value_ error:(NSError**)error_;





@end

@interface _Image (CoreDataGeneratedAccessors)

@end

@interface _Image (CoreDataGeneratedPrimitiveAccessors)


- (NSData*)primitiveLargeImageData;
- (void)setPrimitiveLargeImageData:(NSData*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSData*)primitiveSmallImageData;
- (void)setPrimitiveSmallImageData:(NSData*)value;





- (Directory*)primitiveDirectory;
- (void)setPrimitiveDirectory:(Directory*)value;


@end
