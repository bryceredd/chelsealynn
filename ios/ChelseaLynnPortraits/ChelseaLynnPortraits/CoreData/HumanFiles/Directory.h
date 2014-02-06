#import "_Directory.h"
#import "NSManagedObject+TVJSON.h"

@interface Directory : _Directory <TVJSONManagedObject> {}
- (void) fetchImages;
@end
