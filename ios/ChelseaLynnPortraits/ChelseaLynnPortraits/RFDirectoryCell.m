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

#import "RFQuoteCell.h"
#import "RFChallengeCell.h"
#import "RFChallengeItemCell.h"

@interface RFDirectoryCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageLeadingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* imageWidthContraint;
@end

@implementation RFDirectoryCell

- (void) awakeFromNib {
    for (UIView* view in @[]) {
        /*view.layer.shadowColor = [UIColor blackColor].CGColor;
        view.layer.shadowRadius = 3.f;
        view.layer.shadowOffset = CGSizeZero;
        view.layer.shadowOpacity = 1.f;
        view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        view.layer.shouldRasterize = YES;*/
    }
    
    //RAC(self.imageView, image) =
}

- (void)setDirectory:(Directory*)directory {
    _directory = directory;
    
    /*[self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:self.challenge.imageUrl] placeholderImage:nil success:^(NSURLRequest* request, NSHTTPURLResponse* response, UIImage* image) {
        
        if (!image.size.width || !image.size.height)
            return;
        
        float ratio = image.size.width / image.size.height;
        float width = self.frame.size.height * ratio;
        float x = (self.frame.size.width - width) / 2.f;
        
        self.imageWidthContraint.constant = width;
        self.imageLeadingContraint.constant = x;
        
        [self updateConstraintsIfNeeded];
        
    } failure:nil];*/
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
