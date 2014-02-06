//
//  TVService.h
//  tvtag_new
//
//  Created by Layne Moseley on 4/26/12.
//  Copyright (c) 2012 i.TV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

@interface TVService : NSObject

+ (RACSignal*) image:(NSString*)image;
+ (RACSignal*) get:(NSString*)path;
+ (RACSignal*) post:(NSString*)path params:(NSDictionary*)params;

@end


