//
//  RFRootViewController.m
//  DailyChallenge
//
//  Created by Bryce Redd on 4/19/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "RFRootViewController.h"
#import "RFDirectoryCell.h"
#import "ChelseaLynnApi.h"
#import "RFMacros.h"
#import "RFDirectoriesViewModel.h"

@interface RFRootViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) RFDirectoriesViewModel* viewmodel;
@end

@implementation RFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self, viewmodel.directories) subscribeNext:^(id _) {
        [self.collectionView reloadData];
    }];
    
    UICollectionViewFlowLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = self.collectionView.bounds.size;
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.viewmodel.directoryCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RFDirectoryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"RFDirectoryCell" forIndexPath:indexPath];
    cell.directory = [self.viewmodel directoryAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    float pixelsToNudge = 100;
    
    for (RFDirectoryCell* cell in [self.collectionView visibleCells]) {
        float distFromContentOffset = scroll.contentOffset.x - cell.frame.origin.x;
        float percentOnScreen = distFromContentOffset / self.collectionView.frame.size.width;
        [cell nudgeImage:percentOnScreen*pixelsToNudge];
    }
}

@end
