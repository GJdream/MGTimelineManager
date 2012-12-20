//
//  NSDate+Convert.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 12/16/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "NSDate+Convert.h"

@implementation NSDate (Convert)

+ (NSDate*) convertTwitterDate:(NSString *)twitterDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE MMM dd HH:mm:ss z yyyy"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    return [formatter dateFromString:twitterDate];
}

@end
