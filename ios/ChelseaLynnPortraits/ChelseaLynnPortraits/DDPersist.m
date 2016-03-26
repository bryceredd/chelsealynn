//  DDPersist.m
//  Created by ThD

#import "DDPersist.h"


#define         STORES_DIR_NAME      @"CoreDataStores"


@interface DDPersist()

@property (strong, nonatomic) MOC * mainCtx;
@property (nonatomic, copy) NSString * modelName;
@property (nonatomic, copy) NSString * storesPath;
@property (strong, nonatomic) NSManagedObjectModel * managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator * storeCoordinator;

- (id)initWithModelName:(NSString*)modelName removeOldStores:(BOOL)remove;
- (BOOL)prepareStoresPath;
- (BOOL)removeOldStoresFromDisk;
- (NSURL*)docsURL;
- (NSURL*)storeURL;
- (void)didSaveContextNotification:(NSNotification*)notification;


@end




static DDPersist * _manager = nil;

@implementation DDPersist

+ (BOOL)initializeFromModel:(NSString*)modelName {
    return [DDPersist initializeFromModel:modelName removeOldStores:NO];
}

+ (BOOL)initializeFromModel:(NSString*)modelName removeOldStores:(BOOL)remove {
    NSAssert([NSThread isMainThread], @"DDPERSIST MUST BE INITIALIZED FROM MAIN THREAD!");
    if(![NSThread isMainThread]) return NO;
    _manager = [[DDPersist alloc] initWithModelName:modelName removeOldStores:remove];
    return (_manager != nil);
}

+ (DDPersist *)manager {
    NSAssert(_manager, @"MUST CALL initializeFromModel:removeOldStores: FIRST TO MAKE THE MANAGER AVAILABLE!");
    return _manager;
}

+ (MOC *)mainContext {
    NSAssert([NSThread isMainThread], @"MAIN CONTEXT NEEDS TO BE ACCESSED ON MAIN THREAD!!!");
    if(![NSThread isMainThread]) return nil;
    return [[DDPersist manager] mainCtx];
}

+ (void)mainContext:(MOCBlock)block {
    if(block == nil) return;
    [[[DDPersist manager] mainCtx] performBlock:^{
        block([DDPersist mainContext]);
    }];
}

/* used by NSManagedObjectContext category */
+ (BOOL)isMainContext:(MOC*)ctx {
    return (ctx == [[DDPersist manager] mainCtx]);
}

+ (NSPersistentStoreCoordinator *)storeCoo {
    return [[DDPersist manager] storeCoordinator];
}

+ (BOOL)removeAllStoresFromDisk {
    NSString * docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * storesPath = [docsPath stringByAppendingPathComponent:STORES_DIR_NAME];
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * contents = [fm contentsOfDirectoryAtPath:storesPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString * filename;
    while ((filename = [e nextObject]))
        [fm removeItemAtPath:[storesPath stringByAppendingPathComponent:filename] error:NULL];
    _manager = nil;
    return YES;
}


#pragma mark - Init
- (id)initWithModelName:(NSString*)modelName removeOldStores:(BOOL)remove {
    NSAssert([NSThread isMainThread], @"DDPERSIST NEEDS TO BE INITIALIZED ON MAIN THREAD!");
    if(![NSThread isMainThread]) return nil;
    NSAssert(modelName, @"INVALID MODEL NAME PASSED TO INITIALIZED CORE DATA STORE");
    if(!modelName || [modelName length] == 0) return nil;
    if(self = [super init]) {
        self.modelName = modelName;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didSaveContextNotification:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:nil];
        
        //  Remove old stores if requested!
        if(remove) {
            BOOL cleaned = [self removeOldStoresFromDisk];
            NSAssert(cleaned, @"Could not remove old core data stores from disk!");
            if(!cleaned) return nil;
        }
        [self setStoreCoordinator:nil]; // force new store every time initWithStoreName is called!
        NSPersistentStoreCoordinator * coordinator = [self storeCoordinator];
        self.mainCtx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [self.mainCtx setPersistentStoreCoordinator:coordinator];
        [self.mainCtx setMergePolicy:NSMergeByPropertyStoreTrumpMergePolicy];
    } return self;
}

//  Merge
- (void)didSaveContextNotification:(NSNotification*)notification {
    NSManagedObjectContext * savedContext = [notification object];
    if(self.mainCtx == savedContext) return;
    if(self.storeCoordinator != savedContext.persistentStoreCoordinator) return;
    [DDPersist mainContext:^(NSManagedObjectContext *ctx) {
        [ctx mergeChangesFromContextDidSaveNotification:notification];
        if(DDPersistDebugLog)
            NSLog(@"_merged_context_");
    }];
}

- (BOOL)removeOldStoresFromDisk {
    //  any store that does not use the name self.modelName needs to be deleted from disk!
    NSAssert([NSThread isMainThread], @"YOU MUST INITILIZE THE CORE DATA STORE FROM THE MAIN THREAD!");
    if(![NSThread isMainThread]) return NO;
    NSString * extension = @"sqlite";
    NSFileManager * fm = [NSFileManager defaultManager];
    NSArray * contents = [fm contentsOfDirectoryAtPath:self.storesPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString * filename;
    while ((filename = [e nextObject])) {
        if ([[filename pathExtension] isEqualToString:extension] && ![filename isEqualToString:[self.modelName stringByAppendingPathExtension:extension]])
            [fm removeItemAtPath:[self.storesPath stringByAppendingPathComponent:filename] error:NULL];
    }
    return YES;
}

- (NSURL*)docsURL {
    NSURL * docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return docsURL;
}

- (NSString *)storesPath {
    if(_storesPath != nil) return _storesPath;
    [self prepareStoresPath];
    NSLog(@"CORE DATA STORES PATH IS NOW <%@>", self.storesPath);
    return _storesPath;
}

- (NSURL*)storeURL {
    NSURL * storesPathURL = [NSURL fileURLWithPath:self.storesPath];
    NSURL * storeURL = [storesPathURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", self.modelName]];
    NSLog(@"SOTRE URL WILL BE <%@>", storeURL);
    return storeURL;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) { return _managedObjectModel; }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (BOOL)prepareStoresPath {
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * storesPath = [docsPath stringByAppendingPathComponent:STORES_DIR_NAME];
    BOOL isDir;
    if(![fm fileExistsAtPath:storesPath isDirectory:&isDir]) {
        //  NO STORES PATH IS FOUND. CREATE IT.
        NSError * error;
        BOOL created = [fm createDirectoryAtPath:storesPath withIntermediateDirectories:YES attributes:nil error:&error];
        if(!created || error) {
            NSAssert(0, @"UNABLE TO CREATE CORE DATA STORES PATH!");
            return NO;
        }
    }
    self.storesPath = storesPath;
    return YES;
}

- (NSPersistentStoreCoordinator *)storeCoordinator {
    if (_storeCoordinator != nil) { return _storeCoordinator; }
    
    NSURL * storeURL = [self storeURL];
    NSManagedObjectModel * model = [self managedObjectModel];
    NSPersistentStoreCoordinator * storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //  Will write to disk new core data store!
    NSError * error = nil;
    [storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
                                             URL:storeURL options:nil error:&error];
    NSAssert(!error,@"INVALID PERSISTENT STORE! ERROR: <%@>", [error debugDescription]);
    _storeCoordinator = storeCoordinator;
    return _storeCoordinator;
}


#pragma mark - BACKGROUND
+ (void)performTaskOnBackgroundCtx:(void(^)(MOC * bgCtx))bgCtx {
    if(bgCtx == nil) return;
    NSManagedObjectContext * bgContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    bgContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    bgContext.persistentStoreCoordinator = [DDPersist storeCoo];
    [bgContext performBlock:^{
        bgCtx(bgContext);
    }];
}

+ (void)performTaskOnQueue:(dispatch_queue_t)queue queueContext:(void(^)(MOC * ctxInQueue))ctx {
    if(ctx == nil) return;
    dispatch_async(queue, ^{
        NSManagedObjectContext * context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        context.persistentStoreCoordinator = [DDPersist storeCoo];
        ctx(context);
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

