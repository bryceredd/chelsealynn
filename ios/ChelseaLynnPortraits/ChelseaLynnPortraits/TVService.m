//
//  TVService.m
//  tvtag_new
//
//  Created by Layne Moseley on 4/26/12.
//  Copyright (c) 2012 i.TV. All rights reserved.
//

#import "TVService.h"
#import "AFNetworking.h"

@interface TVService()
@property(nonatomic) RACSubject* subject;
@property(nonatomic) NSString* path;
@property(nonatomic) NSMutableURLRequest* request;
@property(nonatomic) AFHTTPRequestOperation* operation;
@end

@implementation TVService

+ (AFHTTPRequestOperationManager*) client {
    static AFHTTPRequestOperationManager* client = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/", API_URL]]];
        //[client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    });
    
    return client;
}

+ (instancetype) serviceWithMethod:(NSString*)method path:(NSString*)path params:(NSDictionary*)params callback:(TVServiceCompletion)cb {
    TVService* service = [self new];
    service.path = path;
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:path relativeToURL:[self client].baseURL]];
    [request setTimeoutInterval:TIMEOUT_INTERVAL];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accepts"];
    
    if (params != nil) {
        [service.request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    service.operation = [[self client] HTTPRequestOperationWithRequest:service.request
                                           success:[service success:cb]
                                           failure:[service failure]];
    
    NSLog(@"Requesting %@: [%@] %@", method, self, path);
    [service.operation start];
    return service;
}

+ (instancetype) get:(NSString*)path callback:(TVServiceCompletion)callback {
    return [self serviceWithMethod:@"GET" path:path params:nil callback:callback];
}

+ (instancetype) post:(NSString*)path params:(id)params callback:(TVServiceCompletion)callback {
    return [self serviceWithMethod:@"POST" path:path params:params callback:callback];
}

+ (instancetype) delete:(NSString*)path callback:(TVServiceCompletion)callback {
    return [self serviceWithMethod:@"DELETE" path:path params:nil callback:callback];
}

+ (instancetype) put:(NSString*)path params:(id)params callback:(TVServiceCompletion)callback {
    return [self serviceWithMethod:@"PUT" path:path params:params callback:callback];
}

+ (instancetype) request:(NSString*)path method:(NSString*)method params:(id)params success:(TVSuccessCallback)cb {
    __block __weak TVService* service = [self serviceWithMethod:method path:path params:params callback:^(id json) {
        if(cb) cb(service.operation.response.statusCode < 400 && !service.isCanceled);
    }];
    
    // it's important to note that the success callback
    // should callback when an error occurs.  though sometimes
    // the error callback get triggered when a parsing error fails.
    // We treat that case as a "success" as the response code is < 400
    
    service.onError = ^(id obj) {
        if(cb) cb(service.operation.response.statusCode < 400 && !service.isCanceled);
    };
    
    return service;
}

+ (instancetype) image:(NSString*)url success:(TVServiceCompletion)callback {
    return [self serviceWithMethod:@"GET" path:url params:nil callback:callback];
}

- (void) cancel {
    NSLog(@"Canceling: [%@] %@", [self class], self.operation.request.URL);
    self.isCanceled = YES;
    [self.operation cancel];
}

- (void (^)(AFHTTPRequestOperation* operation, NSError *error)) failure {
    return ^(AFHTTPRequestOperation* operation, NSError *error) {
        
        if(self.isCanceled)
            NSLog(@"%@ canceled! : [%@]", [self class], self.path);
        
        else if(operation.responseString || operation.response.statusCode >= 400)
            NSLog(@"Request failed : [%@] %@ method=%@ statusCode=%i data=%@", [self class], operation.request.URL,  operation.request.HTTPMethod, operation.response.statusCode, operation.responseString);
        
        
        if(self.onError) {
            self.onError([NSJSONSerialization JSONObjectWithData:operation.responseData options:kNilOptions error:nil]);
            
            self.operation = nil;
        };
    };
}

- (void (^)(AFHTTPRequestOperation* operation, id responseObject)) success:(TVServiceCompletion)callback {
    return ^(AFHTTPRequestOperation* operation, id responseObject) {
        if(callback) callback(responseObject);
        
        self.operation = nil;
    };
}

+ (RACSignal*) get:(NSString*)path {
    __weak TVService* service = nil;
    
    service = [self get:path callback:^(id json) {
        [service.subject sendNext:json];
        [service.subject sendCompleted];
    }];
    
    service.onError = ^(id error) {
        [service.subject sendError:error];
    };
    
    service.subject = [RACSubject subject];
    
    return service.subject;
}

@end
