#import "_Image.h"
#import "NSManagedObject+TVJSON.h"

@interface Image : _Image <TVJSONManagedObject> {}
- (RACSignal*) fetchLargeImage;
- (RACSignal*) fetchSmallImage;
@end
