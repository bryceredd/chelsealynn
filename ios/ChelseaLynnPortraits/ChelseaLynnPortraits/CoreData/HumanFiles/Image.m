#import "Image.h"
#import "NSString+TVAdditions.h"
#import "ChelseaLynnApi.h"


@interface Image ()
@end


@implementation Image

+ (NSString *)uniqueIdKey {
    return @"name";
}

- (void) fetchSmallImage {
    [[ChelseaLynnApi image:[NSString stringWithFormat:@"fit/200/200/%@", [self.name stringSafeForURL]]] setKeyPath:@keypath(self, smallImageData) onObject:self];
}

- (void) fetchLargeImage {
    [[[ChelseaLynnApi image:[NSString stringWithFormat:@"fit/1000/1000/%@", [self.name stringSafeForURL]]] subscribeNext:^(id x) {
        self.largeImageData = x;
    }];
            setKeyPath:@keypath(self, largeImageData) onObject:self];
}

@end
