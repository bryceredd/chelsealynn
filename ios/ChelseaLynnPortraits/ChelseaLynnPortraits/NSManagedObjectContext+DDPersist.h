//  NSManagedObjectContext+DDPersistMoc.h
//  Created by ThD

#import <CoreData/CoreData.h>
#import "DDPersist.h"

@interface NSManagedObjectContext (DDPersist)


#pragma mark - INSERT
- (id)insertEntityFromClass:(Class)klass;

#pragma mark - UNIQUENESS
- (BOOL)isEntityUnique:(NSString *)entityName attribute:(NSString *)attribute value:(id)value;

#pragma mark - FETCH
- (id)fetchOneEntity:(Class)klass predicate:(NSPredicate*)predicate;
- (id)fetchOrInsertEntity:(Class)klass withPredicate:(NSPredicate*)predicate;
- (id)fetchOneEntity:(Class)klass withPredicate:(NSPredicate*)predicate sortKey:(NSString*)sortKey ascending:(BOOL)ascending;
- (id)fetchEntities:(Class)klass withPredicate:(NSPredicate*)predicate sortKey:(NSString*)sortKey ascending:(BOOL)ascending;
- (NSArray*)fetchEntities:(Class)klass predicate:(NSPredicate*)predicate;
- (NSArray *)fetchEntitesWithName:(NSString *)entityName;
- (NSArray *)fetchEntitesWithName:(NSString *)entityName moIdOnly:(BOOL)moIdOnly;
- (NSArray *)fetchEntitesWithName:(NSString *)entityName sortAttribute:(NSString *)sortAttribute ascending:(BOOL)ascending moIdOnly:(BOOL)moIdOnly;
- (NSArray *)fetchEntitiesWithName:(NSString *)entityName attribute:(NSString *)attribute value:(id)value;
- (NSManagedObject *)objectWithURI:(NSURL*)uri;


#pragma mark - COUNT
- (NSInteger)countForEntity:(NSString *)entityName;
- (NSInteger)countForEntity:(NSString *)entityName attribute:(NSString *)attribute value:(id)value;
- (NSUInteger)countEntities:(NSString *)name;
- (NSUInteger)countEntities:(NSString *)name withAttribute:(NSString *)attribute value:(id)value;
- (BOOL)persist;


#pragma mark - DELETION
- (BOOL)deleteEntitiesWithName:(NSString *)entityName;
- (BOOL)deleteEntitiesWithName:(NSString *)entityName persist:(BOOL)persist;


@end
