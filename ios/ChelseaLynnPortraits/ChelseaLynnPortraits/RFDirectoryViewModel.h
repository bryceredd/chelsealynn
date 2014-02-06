//
//  RFDirectoryViewModel.h
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/12/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RVMViewModel.h"
#import "RFImageCellViewModel.h"
#import "Directory.h"

@interface RFDirectoryViewModel : RVMViewModel
@property (nonatomic, readonly) Directory* model;

@property (nonatomic, readonly) UIImage* image;
@property (nonatomic, readonly) NSString* name;

- (RFImageCellViewModel*) viewModelForIndex:(NSInteger)index;
- (NSInteger) countOfImages;

@end
