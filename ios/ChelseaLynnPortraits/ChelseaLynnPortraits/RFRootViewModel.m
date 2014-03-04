//
//  RFDirectoriesViewModel.m
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/11/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "RFRootViewModel.h"
#import "RFDirectoryViewModel.h"
#import "ChelseaLynnApi.h"
#import "Image.h"
#import "Directory.h"

@implementation RFRootViewModel

- (void)awakeFromNib {
    
    
    // extra pages that are hard coded
    RACSignal* hardcodedValues = [RACSignal return:@[[Directory objectWithObject:@{@"name":@"home"}]]];
    
    RAC(self, model) = [RACSignal
                        combineLatest:@[[ChelseaLynnApi directories], hardcodedValues]
                        reduce:^id(NSArray* directoriesFromApi, NSArray* directoriesFromBinary) {
                            return [directoriesFromBinary arrayByAddingObjectsFromArray:directoriesFromApi];
                        }];
    
}

- (NSInteger) directoryCount {
    return self.model.count;
}

- (NSString*) typeOfCellForIndex:(NSInteger)index {
    return index == 0? @"RFClientCell" : @"RFDirectoryCell";
}

- (RFDirectoryViewModel*) directoryAtIndex:(NSInteger)index {
    if(index < 0 || index > self.model.count - 1)
        return nil;
    
    return [[RFDirectoryViewModel alloc] initWithModel:self.model[index]];
}

@end
