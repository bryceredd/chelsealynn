//
//  NSManagedObject+RFCacheableStream.m
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/12/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import "NSObject+RFCacheableStream.h"
#import <objc/runtime.h>

@implementation NSObject (RFCacheableStream)

- (RACSignal*) fetchForKey:(NSString*)key stream:(RACSignal*)signal {
    //if([self valueForKey:key]) return;
    
    @synchronized (self) {
        RACSignal* sig = objc_getAssociatedObject(self, (__bridge const void *)(key));
        if(sig)
            return sig;
    }
    
    [signal setKeyPath:key onObject:self];
    @synchronized (self) {
        objc_setAssociatedObject(self, (__bridge const void *)(key), signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [signal subscribeNext:^(id _) {
        @synchronized (self) {
            objc_removeAssociatedObjects(key);
        }
    }];
    
    return signal;
}

@end
