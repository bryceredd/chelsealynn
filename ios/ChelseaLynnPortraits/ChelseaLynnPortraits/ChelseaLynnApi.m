//
//  RFChallengeService.m
//  DailyChallenge
//
//  Created by Bryce Redd on 4/22/12.
//  Copyright (c) 2012 Itv. All rights reserved.
//

#import "ChelseaLynnApi.h"
#import "Directory.h"
#import "Image.h"
#import "TVService.h"
#import "NSManagedObject+TVJSON.h"

@implementation ChelseaLynnApi

#ifdef DEBUG
NSString* baseUrl = @"localhost:2442";
#else
NSString* baseUrl = @"chelsealynnportraits.com";
#endif


+ (RACSignal*) directories {
    return [self get:@"directories" class:[Directory class]];
}

+ (RACSignal*) imagesForDirectory:(NSString*)directoryName {
    return [self get:[NSString stringWithFormat:@"image/%@", directoryName] class:[Image class]];
}


// helper function

+ (RACSignal*) image:(NSString*)image {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", baseUrl, image]];
    
    return [[NSURLConnection rac_sendAsynchronousRequest:[NSURLRequest requestWithURL:url]]
            map:^id(NSData* data) {
                return [UIImage imageWithData:data];
            }];
}

+ (RACSignal*) get:(NSString*)get class:(Class)klass {
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", baseUrl, get]];
    
    return [[[[[[NSURLConnection
                 rac_sendAsynchronousRequest:[NSURLRequest requestWithURL:url]]
                map:^id(NSData* data) {
                    return[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                }]
               deliverOn:[RACScheduler mainThreadScheduler]]
              map:^id(id json) {
                  return [klass objectWithObject:json];
              }]
             publish]
            autoconnect];
}

@end
