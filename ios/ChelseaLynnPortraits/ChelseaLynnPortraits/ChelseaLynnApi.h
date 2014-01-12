//
//  RFChallengeService.h
//  DailyChallenge
//
//  Created by Bryce Redd on 4/22/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChelseaLynnApi : NSObject
+ (RACSignal*) image:(NSString*)image;
+ (RACSignal*) directories;
+ (RACSignal*) imagesForDirectory:(NSString*)directoryName;
@end
