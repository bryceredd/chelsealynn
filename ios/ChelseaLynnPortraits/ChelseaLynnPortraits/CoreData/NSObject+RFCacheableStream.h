//
//  NSManagedObject+RFCacheableStream.h
//  ChelseaLynnPortraits
//
//  Created by Bryce Redd on 1/12/14.
//  Copyright (c) 2014 Bryce Redd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSObject (RFCacheableStream)

// take a source stream and a key.  the sequence of caching goes
// as follows:
//
// 1. the model object checks the value for the key.  if it's there,
// then that value is immediately returned via a racsignal
//
// 2. a previous signal is searched for.  if the signal is there, then
// the request must be en route, and the multicasted signal will return
// a subscribed stream.
//
// 3. the source stream will be used to fetch the data, then cached
// in the key, and the stream terminated.

- (RACSignal*) fetchForKey:(NSString*)key stream:(RACSignal*)signal;

@end
