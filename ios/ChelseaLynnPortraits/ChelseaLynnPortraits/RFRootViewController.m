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
#import "RFRootViewModel.h"
#import "RFDirectoryBrowserViewController.h"

@interface RFRootViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet RFRootViewModel* viewmodel;
@end

@implementation RFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACObserve(self, viewmodel.model) subscribeNext:^(id _) {
        [self.collectionView reloadData];
    }];
    
    UICollectionViewFlowLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.minimumInteritemSpacing = 0.f;
    layout.minimumLineSpacing = 0.f;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.itemSize = self.collectionView.bounds.size;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    RFDirectoryBrowserViewController* controller = segue.destinationViewController;
    controller.viewmodel = sender;
}


#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.viewmodel.directoryCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString* reuseIdentifier = [self.viewmodel typeOfCellForIndex:indexPath.row];
    RFDirectoryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.directory = [self.viewmodel directoryAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RFDirectoryViewModel* directoryViewModel = [self.viewmodel directoryAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"to_directory" sender:directoryViewModel];;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    float pixelsToNudge = 100;
    
    for (RFDirectoryCell* cell in [self.collectionView visibleCells]) {
        float distFromContentOffset = scroll.contentOffset.x - cell.frame.origin.x;
        float percentOnScreen = distFromContentOffset / self.collectionView.frame.size.width;
        [cell nudgeImage:percentOnScreen*pixelsToNudge];
    }
}

@end
