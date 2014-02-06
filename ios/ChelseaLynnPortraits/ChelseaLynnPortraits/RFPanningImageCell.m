//
//  RFPanningImageCell.m
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/24/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RFPanningImageCell.h"

@implementation RFPanningImageCell

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    RAC(self, imageView.image) = RACObserve(self, image.image);
    
    return self;
}



@end
