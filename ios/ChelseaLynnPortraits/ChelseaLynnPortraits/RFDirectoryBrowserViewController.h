//
//  RFDirectoryBrowserViewController.h
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/24/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFDirectoryViewModel.h"

@interface RFDirectoryBrowserViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic) RFDirectoryViewModel* viewmodel;
@end
