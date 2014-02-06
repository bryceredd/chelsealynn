//
//  TVService.m
//  tvtag_new
//
//  Created by Layne Moseley on 4/26/12.
//  Copyright (c) 2012 i.TV. All rights reserved.
//



#ifdef DEBUG
NSString* baseUrl = @"localhost:2442/";
#else
NSString* baseUrl = @"chelsealynnportraits.com/";
#endif



#import "TVService.h"

@interface RACSignal (TVService)
- (RACSignal*) requestToJSONMap;
- (RACSignal*) requestToImageMap;
- (RACSignal*) requestToImageDataMap;
- (RACSignal*) requestIsValid;
@end

@interface TVService()
@property(nonatomic) NSString* path;
@property(nonatomic) RACSubject* subject;
@property(nonatomic) NSMutableURLRequest* request;
@end

@implementation TVService

+ (NSString*) api {
    return baseUrl;
}

+ (RACSignal*) get:(NSString*)path {
    return [self send:[self requestWithPath:path method:@"GET"]];
}

+ (RACSignal*) post:(NSString*)path params:(NSDictionary*)params {
    NSMutableURLRequest* request = [self requestWithPath:path method:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:kNilOptions error:nil]];
    
    return [self send:request];
}

+ (RACSignal*) image:(NSString*)path {
    NSURLRequest* request = [self requestWithPath:path method:@"GET"];
    NSLog(@"getting image: %@", request.URL.absoluteString);
    
    return [[[[[[[NSURLConnection
                  rac_sendAsynchronousRequest:request]
                 logError]
                requestIsValid]
               requestToImageDataMap]
              deliverOn:[RACScheduler mainThreadScheduler]]
             publish]
            autoconnect];
}


+ (RACSignal*) send:(NSURLRequest*)request {
    
    NSString* params = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSString* url = request.URL.absoluteString;
    
    if(url.length > 100)
        url = [NSString stringWithFormat:@"%@...", [url substringWithRange:NSMakeRange(0, 99)]];
    
    NSLog(@"%@ing url: %@ %@", request.HTTPMethod, url, params? params: @"");
    
    return [[[[[[[NSURLConnection
                  rac_sendAsynchronousRequest:request]
                 logError]
                requestIsValid]
               requestToJSONMap]
              deliverOn:RACScheduler.mainThreadScheduler]
             publish]
            autoconnect];
}


// helper

+ (NSMutableURLRequest*) requestWithPath:(NSString*)path method:(NSString*)method {
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@", self.api, path]];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:method];
    
    return request;
}


@end

@implementation RACSignal (TVService)

- (RACSignal*) requestIsValid {
    return [self filter:^BOOL(RACTuple* tuple) {
        NSHTTPURLResponse* response = [tuple first];
        return response.statusCode < 400;
    }];
}

- (RACSignal*) requestToJSONMap {
    return [self map:^id(RACTuple* tuple) {
        return [NSJSONSerialization JSONObjectWithData:[tuple second] options:0 error:nil];
    }];
}

- (RACSignal*) requestToImageDataMap {
    return [self map:^UIImage*(RACTuple* tuple) {
        return [tuple second];
    }];
}

- (RACSignal*) requestToImageMap {
    return [self map:^UIImage*(RACTuple* tuple) {
        return [UIImage imageWithData:[tuple second]];
    }];
}

@end

