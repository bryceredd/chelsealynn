//
//  RFDirectoryViewModel.m
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/12/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RFDirectoryViewModel.h"
#import "Image.h"
#import "Directory.h"
#import "RACSignal+RFCommonSignals.h"


@interface RFDirectoryViewModel()
@property Image* displayedImage;
@end


@implementation RFDirectoryViewModel

- (instancetype)initWithModel:(id)model {
    self = [super initWithModel:model];
    
    RAC(self, displayedImage) = [[RACObserve(self, model.images) notNil] mapWithSelector:@selector(firstObject)];
    
    [RACObserve(self, displayedImage) subscribeNext:^(Image* image) {
        [image fetchLargeImage];
    }];
    
    RAC(self, image) = [RACObserve(self, displayedImage.largeImageData) dataToImage];
    
    [self.model fetchImages];
    
    return self;
}

- (RFImageCellViewModel*) viewModelForIndex:(NSInteger)index {
    if(index < 0 || index > self.model.images.count -1)
        return nil;
        
    return [[RFImageCellViewModel alloc] initWithModel:self.model.images[index]];
}

- (NSInteger) countOfImages {
    return self.model.images.count;
}

- (NSString*) name {
    return self.model.name;
}

@end
