//
//  RFSignals+RACSignal.h
//  tvtag_new
//
//  Created by Bryce Redd on 7/9/13.
//  Copyright (c) 2013 i.TV. All rights reserved.
//

#import "ReactiveCocoa.h"

@interface RACSignal (RFCommonSignals)

// maps an incoming signal to an nsnumber
- (RACSignal*) truthy;

// maps an incoming signal to an nsnumber
- (RACSignal*) reverseTruthy;

// maps an incoming nsnumber y value
// to a cgrect nsvalue
- (RACSignal*) rectWithY:(RACSignal*)frameSignal;

- (RACSignal*) mapWithSelector:(SEL)selector;

- (RACSignal*) notNil;

// moves a data signal into an image
- (RACSignal*) dataToImage;

// uses combinelatest to or the results together
// and return the answer
+ (RACSignal*) or:(id<NSFastEnumeration>)signals;
+ (RACSignal*) and:(id<NSFastEnumeration>)signals;

// always will be an uppercase string
- (RACSignal*) uppercaseString;

- (RACSignal*) mapIsEqual:(id)obj;
- (RACSignal*) filterTruthy;
- (RACSignal*) filterClass:(Class)klass;
@end

