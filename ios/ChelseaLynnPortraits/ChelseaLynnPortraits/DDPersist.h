//  DDPersist.h
//  Created by ThD

#import <Foundation/Foundation.h>
#import "NSManagedObjectContext+DDPersist.h"

typedef NSManagedObjectContext MOC;
typedef NSManagedObjectID MOID;
typedef void(^MOCBlock)(MOC * ctx);
typedef void(^MocIdBlock)(MOID * mocId);


#define DDPersistDebugLog 1



@interface DDPersist : NSObject

+ (BOOL)initializeFromModel:(NSString*)modelName;

+ (BOOL)initializeFromModel:(NSString*)modelName removeOldStores:(BOOL)remove;

+ (DDPersist *)manager;

+ (MOC *)mainContext;  //  CALL FROM MAIN THREAD

+ (void)mainContext:(MOCBlock)block;   //  CALL FROM ANY THREAD

+ (BOOL)isMainContext:(MOC*)ctx;

+ (NSPersistentStoreCoordinator *)storeCoo;

+ (BOOL)removeAllStoresFromDisk;

+ (void)performTaskOnBackgroundCtx:(void(^)(MOC * bgCtx))bgCtx;

+ (void)performTaskOnQueue:(dispatch_queue_t)queue queueContext:(void(^)(MOC * ctxInQueue))ctx;

@end
