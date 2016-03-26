//
//  NSString+TVAdditions.m
//  tvtag_new
//
//  Created by Layne Moseley on 8/20/12.
//  Copyright (c) 2012 i.TV. All rights reserved.
//

#import "NSString+TVAdditions.h"

@implementation NSString (TVAdditions)

- (NSString *) stringSafeForURL {
    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(NULL,
																	(CFStringRef)self,
																	NULL,
																	(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
																	kCFStringEncodingUTF8 );
	NSString *safeString = [NSString stringWithFormat:@"%@", (__bridge NSString*)stringRef];
	return safeString;
}


@end
