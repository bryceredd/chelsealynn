//
//  RFDirectoriesViewModel.h
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/11/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RVMViewModel.h"
#import "Directory.h"

@interface RFDirectoriesViewModel : RVMViewModel
@property (nonatomic) NSArray* directories;
- (NSInteger) directoryCount;
- (Directory*) directoryAtIndex:(NSInteger)index;
@end
