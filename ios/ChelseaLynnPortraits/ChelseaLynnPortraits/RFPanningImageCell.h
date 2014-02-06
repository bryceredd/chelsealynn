//
//  RFPanningImageCell.h
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/24/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFImageCellViewModel.h"

@interface RFPanningImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic) RFImageCellViewModel* image;
@end
