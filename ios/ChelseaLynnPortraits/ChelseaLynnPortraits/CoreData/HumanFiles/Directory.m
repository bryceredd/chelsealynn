#import "Directory.h"
#import "ChelseaLynnApi.h"


@interface Directory ()
@end


@implementation Directory

+ (NSString *)uniqueIdKey {
    return @"name";
}

- (void) fetchImages {
    [self fetchForKey:@"images" stream:[ChelseaLynnApi imagesForDirectory:self.name]];
}

@end
