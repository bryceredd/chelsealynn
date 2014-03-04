//
//  RFImageCell.m
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/24/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RFImageCellViewModel.h"
#import "ChelseaLynnApi.h"
#import "Image.h"
#import "RACSignal+RFCommonSignals.h"

@interface RFImageCellViewModel ()
@property (nonatomic) Image* model;
@end

@implementation RFImageCellViewModel

- (instancetype)initWithModel:(Image*)model {
    self = [super initWithModel:model];
    
    RAC(self, image) = [RACObserve(model, smallImageData) dataToImage];
    
    return self;
}

@end
