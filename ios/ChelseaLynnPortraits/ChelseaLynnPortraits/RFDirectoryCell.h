//
//  RFDayViewController.h
//  DailyChallenge
//
//  Created by Bryce Redd on 4/22/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Directory.h"

@interface RFDirectoryCell : UICollectionViewCell

@property (nonatomic) Directory* directory;

- (void) nudgeImage:(float)pixels;
@end
