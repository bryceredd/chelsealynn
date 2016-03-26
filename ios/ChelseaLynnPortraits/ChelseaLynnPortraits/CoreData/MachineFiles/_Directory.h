// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Directory.h instead.

#import <CoreData/CoreData.h>


extern const struct DirectoryAttributes {
	__unsafe_unretained NSString *name;
} DirectoryAttributes;

extern const struct DirectoryRelationships {
	__unsafe_unretained NSString *images;
} DirectoryRelationships;

extern const struct DirectoryFetchedProperties {
} DirectoryFetchedProperties;

@class Image;



@interface DirectoryID : NSManagedObjectID {}
@end

@interface _Directory : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DirectoryID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *images;

- (NSMutableOrderedSet*)imagesSet;





@end

@interface _Directory (CoreDataGeneratedAccessors)

- (void)addImages:(NSOrderedSet*)value_;
- (void)removeImages:(NSOrderedSet*)value_;
- (void)addImagesObject:(Image*)value_;
- (void)removeImagesObject:(Image*)value_;

@end

@interface _Directory (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableOrderedSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableOrderedSet*)value;


@end
