//
//  RFSignals+RACSignal.m
//  tvtag_new
//
//  Created by Bryce Redd on 7/9/13.
//  Copyright (c) 2013 i.TV. All rights reserved.
//

#import "RACSignal+RFCommonSignals.h"

@implementation RACSignal (RFCommonSignals)

- (RACSignal*) truthy {
    return [self map:^(id item) {
        if([item isKindOfClass:[NSNumber class]]) {
            return (NSNumber*)item;
        }
        
        if([item isKindOfClass:[NSString class]]) {
            return @([(NSString*)item length]);
        }
        
        return @(!!item);
    }];
}

- (RACSignal*) dataToImage {
    return [self map:^UIImage*(NSData* data) {
        return [UIImage imageWithData:data];
    }];
}

- (RACSignal*) reverseTruthy {
    return [[self truthy] map:^(id number) {
        NSNumber* num = number;
        return @(![num boolValue]);
    }];
}

- (RACSignal*) rectWithY:(RACSignal*)frameSignal {
    return [RACSignal combineLatest:@[self, [frameSignal distinctUntilChanged]] reduce:^(NSNumber* y, NSValue* frame) {
        CGRect rect = frame.CGRectValue;
        rect.origin.y = y.floatValue;
        return [NSValue valueWithCGRect:rect];
    }];
}

- (RACSignal*) mapWithSelector:(SEL)selector {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self map:^(NSObject* item)  {
        return [item performSelector:selector];
    }];
    #pragma clang diagnostic pop
}

- (RACSignal*) mapIsEqual:(id)obj {
    return [self map:^(id incoming) {
        return @([incoming isEqual:obj]);
    }];
}

- (RACSignal*) filterTruthy {
    return [self filter:^BOOL(id value) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
        return !!value;
    }];
}

- (RACSignal*) filterClass:(Class)klass {
    return [self filter:^BOOL(id value) {
        return [value isKindOfClass:klass];
    }];
}

- (RACSignal*) notNil {
    return [self filter:^BOOL(id value) {
        if(!value || [value isKindOfClass:[NSNull class]])
            return NO;
        return YES;
    }];
}

+ (RACSignal*) or:(id<NSFastEnumeration>)signals {
    return [[RACSignal combineLatest:signals] map:^(RACTuple* tuple) {
        BOOL ans = NO;
        for(NSNumber* obj in tuple) {
            if([obj isKindOfClass:[RACTupleNil class]]) {
                ans |= NO;
                continue;
            }
            ans |= obj.boolValue;
        }
        return @(ans);
    }];
}

+ (RACSignal*) and:(id<NSFastEnumeration>)signals {
    return [[RACSignal combineLatest:signals] map:^(RACTuple* tuple) {
        BOOL ans = YES;
        for(NSNumber* obj in tuple) {
            if([obj isKindOfClass:[RACTupleNil class]]) {
                ans &= NO;
                continue;
            }
            ans &= obj.boolValue;
        }
        return @(ans);
    }];
}

- (RACSignal*) uppercaseString {
    return [self map:^(NSString* str) { return [str uppercaseString]; }];
}

@end
