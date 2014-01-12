//
//  TVService.h
//  tvtag_new
//
//  Created by Layne Moseley on 4/26/12.
//  Copyright (c) 2012 i.TV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"

#define API_URL @"localhost:2442"
#define TIMEOUT_INTERVAL (20.f)


typedef void(^TVServiceCompletion)(id result);
typedef void (^TVArrayCallback)(NSArray *array);
typedef void (^TVDictionayCallback)(NSDictionary *dictionary);
typedef void (^TVSuccessCallback)(BOOL success);


@interface TVService : NSObject

@property (nonatomic, copy) TVServiceCompletion onError;
@property (nonatomic, assign) BOOL isCanceled;

- (void) cancel;

+ (instancetype) get:(NSString*)path callback:(TVServiceCompletion)callback;
+ (instancetype) post:(NSString*)path params:(id)params callback:(TVServiceCompletion)complete;
+ (instancetype) put:(NSString*)path params:(id)params callback:(TVServiceCompletion)complete;
+ (instancetype) delete:(NSString*)path callback:(TVServiceCompletion)callback;

+ (instancetype) request:(NSString*)path method:(NSString*)method params:(id)params success:(TVSuccessCallback)cb;
+ (instancetype) image:(NSString*)url success:(TVServiceCompletion)callback;

+ (RACSignal*) get:(NSString*)path;

@end
