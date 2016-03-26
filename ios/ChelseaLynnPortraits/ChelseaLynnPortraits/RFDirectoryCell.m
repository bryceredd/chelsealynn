//
//  RFDayViewController.m
//  DailyChallenge
//
//  Created by Bryce Redd on 4/22/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "RFDirectoryCell.h"
#import "RFMacros.h"
#import "ChelseaLynnApi.h"
#import "UIImageView+AFNetworking.h"

@interface RFDirectoryCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageLeadingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageWidthContraint;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *shadowedLabels;
@end

@implementation RFDirectoryCell

- (void) awakeFromNib {
    for (UIView* view in self.shadowedLabels) {
        view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowRadius = 3.f;
        view.layer.shadowOffset = CGSizeZero;
        view.layer.shadowOpacity = 1.f;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        view.layer.shouldRasterize = YES;
    }
    
    RAC(self.name, text) = RACObserve(self, directory.name);
    RAC(self.imageView, image) = RACObserve(self, directory.image);
    
    RACSignal* imageRatio = [[RACObserve(self.imageView, image) notNil] map:^NSNumber*(UIImage* image) {
       return @(image.size.width / image.size.height);
    }];
    
    RACSignal* imageWidth = [[RACObserve(self.imageView, image) notNil] map:^NSNumber*(UIImage* image) {
        return @(image.size.width);
    }];
    
    RACSignal* frameWidth = [RACObserve(self, frame) map:^NSNumber*(NSValue* value) {
        return @(value.CGRectValue.size.height);
    }];
    
    RACSignal* frameHeight = [RACObserve(self, frame) map:^NSNumber*(NSValue* value) {
        return @(value.CGRectValue.size.height);
    }];
    
    RAC(self, imageWidthContraint.constant) = [RACSignal combineLatest:@[frameHeight, imageRatio] reduce:^(NSNumber* frameHeight, NSNumber* imageRatio) {
        return @(frameHeight.floatValue * imageRatio.floatValue);
    }];
    
    RAC(self, imageLeadingContraint.constant) = [RACSignal combineLatest:@[frameWidth, imageWidth] reduce:^(NSNumber* frameWidth, NSNumber* imageWidth) {
        return @((frameWidth.floatValue - imageWidth.floatValue) / 2.f);
    }];
    
    [RACObserve(self, imageWidthContraint.constant) subscribeNext:^(id _) {
        [self updateConstraintsIfNeeded];
    }];
    
    [RACObserve(self, imageLeadingContraint.constant) subscribeNext:^(id _) {
        [self updateConstraintsIfNeeded];
    }];
}

- (void) nudgeImage:(float)pixels {
    if(!self.imageView.image.size.width || !self.imageView.image.size.height)
        return;
    
    float ratio = self.imageView.image.size.width / self.imageView.image.size.height;
    float width = self.frame.size.height * ratio;
    float x = (self.frame.size.width - width) / 2.f;
    
    setFrameX(self.imageView, x + pixels);
}

@end
