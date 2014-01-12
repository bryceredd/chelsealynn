#import "_Directory.h"
#import "NSManagedObject+TVJSON.h"

@interface Directory : _Directory <TVJSONManagedObject> {}
@property (nonatomic, readonly) RACSignal* image;
@end
