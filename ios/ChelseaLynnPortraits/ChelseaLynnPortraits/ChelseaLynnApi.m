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
#import "DDPersist.h"


@interface RACSignal(ClassMapper)
- (RACSignal*) mapToClass:(Class)klass;
@end


@implementation ChelseaLynnApi

+ (void) load {
    [DDPersist initializeFromModel:@"Model"];
}


+ (RACSignal*) directories {
    return [self get:@"directories" class:[Directory class]];
}

+ (RACSignal*) imagesForDirectory:(NSString*)directoryName {
    return [[self get:[NSString stringWithFormat:@"image/%@", directoryName] class:[Image class]] map:^NSOrderedSet*(NSArray* array) {
        return [NSOrderedSet orderedSetWithArray:array];
    }];
}

+ (RACSignal*) image:(NSString*)image {
    return [TVService image:image];
}

// helper
+ (RACSignal*) get:(NSString*)path class:(Class)klass {
    return [[[TVService get:path] map:^NSArray*(NSArray* value) {
        return [[[value rac_sequence] map:^(NSString* directoryName) {
            return @{@"name":directoryName};
        }] array];
    }] mapToClass:klass];
}

@end

@implementation RACSignal(TVGuideAPI)

- (RACSignal*) mapToClass:(Class)class {
    return [[[self
              deliverOn:RACScheduler.mainThreadScheduler]
             map:^id(id value) {
                 return [class objectWithObject:value];
             }]
            replayLazily];
}

@end