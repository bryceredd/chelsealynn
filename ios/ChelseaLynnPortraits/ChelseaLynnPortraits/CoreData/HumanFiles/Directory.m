#import "Directory.h"
#import "ChelseaLynnApi.h"


@interface Directory ()
@end


@implementation Directory

+ (NSString *)uniqueIdKey {
	return @"name";
}

- (void)fetchImages {
	[[ChelseaLynnApi imagesForDirectory:self.name] setKeyPath:@keypath(self, images) onObject:self];
}

@end
