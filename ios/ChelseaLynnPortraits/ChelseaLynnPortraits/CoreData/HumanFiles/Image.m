#import "Image.h"
#import "NSString+TVAdditions.h"
#import "ChelseaLynnApi.h"


@interface Image ()
@end


@implementation Image

+ (NSString *)uniqueIdKey {
    return @"name";
}

- (RACSignal*) fetchSmallImage {
    return [self fetchForKey:@"smallImageData"
                      stream:[ChelseaLynnApi image:[NSString stringWithFormat:@"fit/200/200/%@", [self.name stringSafeForURL]]]];
}

- (RACSignal*) fetchLargeImage {
    return [self fetchForKey:@"largeImageData"
                      stream:[ChelseaLynnApi image:[NSString stringWithFormat:@"fit/1000/1000/%@", [self.name stringSafeForURL]]]];
}

@end
