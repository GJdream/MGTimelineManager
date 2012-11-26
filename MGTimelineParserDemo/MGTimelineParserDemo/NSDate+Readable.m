//
//  NSDate+Readable.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/25/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "NSDate+Readable.h"

@implementation NSDate (Readable)

- (NSString*) readableString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MMM dd hh:mm a"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    return [dateFormatter stringFromDate:self];
}

@end
