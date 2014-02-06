//
//  RFDirectoryBrowserViewController.m
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/24/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RFDirectoryBrowserViewController.h"
#import "RFPanningImageCell.h"

@interface RFDirectoryBrowserViewController ()

@end

@implementation RFDirectoryBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.viewmodel countOfImages];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RFPanningImageCell* cell = [cv dequeueReusableCellWithReuseIdentifier:@"RFPanningImageCell" forIndexPath:indexPath];
    
    cell.image = [self.viewmodel viewModelForIndex:indexPath.row];
    
    return cell;
}


@end
