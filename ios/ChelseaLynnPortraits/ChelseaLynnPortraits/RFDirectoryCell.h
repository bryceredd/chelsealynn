//
//  RFDayViewController.h
//  DailyChallenge
//
//  Created by Bryce Redd on 4/22/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFDirectoryViewModel.h"

@interface RFDirectoryCell : UICollectionViewCell

@property (nonatomic) RFDirectoryViewModel* directory;

- (void) nudgeImage:(float)pixels;
@end
