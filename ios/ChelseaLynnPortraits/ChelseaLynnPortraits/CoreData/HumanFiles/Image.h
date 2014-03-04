#import "_Image.h"
#import "NSManagedObject+TVJSON.h"

@interface Image : _Image <TVJSONManagedObject> {}
- (void) fetchLargeImage;
- (void) fetchSmallImage;
@end
