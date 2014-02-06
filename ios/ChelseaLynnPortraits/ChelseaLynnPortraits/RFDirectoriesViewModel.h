//
//  RFDirectoriesViewModel.h
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/11/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RVMViewModel.h"
#import "RFDirectoryViewModel.h"

@interface RFDirectoriesViewModel : RVMViewModel
@property (nonatomic, readonly) NSArray* model;
- (NSString*) typeOfCellForIndex:(NSInteger)index;
- (NSInteger) directoryCount;
- (RFDirectoryViewModel*) directoryAtIndex:(NSInteger)index;
@end
