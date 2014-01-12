//
//  RFDirectoriesViewModel.m
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/11/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RFDirectoriesViewModel.h"
#import "ChelseaLynnApi.h"

@implementation RFDirectoriesViewModel

- (instancetype)init {
    self = [super init];
    
    RAC(self, model) = [[[ChelseaLynnApi directories] logError] catchTo:[RACSignal empty]];
    
    return self;
}

- (NSInteger) directoryCount {
    return self.directories.count;
}

- (Directory*) directoryAtIndex:(NSInteger)index {
    if(index < 0 || index > self.directories.count - 1)
        return nil;
    
    return self.directories[index];
}

@end
