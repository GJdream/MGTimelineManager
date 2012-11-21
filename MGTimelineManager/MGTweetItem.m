//
//  MGTweetItem.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTweetItem.h"

@implementation MGTweetItem

@synthesize dateCreated = _dateCreated, data = _data, profileImage = _profileImage, username = _username, bodyText = _bodyText, idString = _idString;

- (UIImage*) profileImage
{
    if (_profileImage == nil) {
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [self.data valueForKeyPath:@"user.profile_image_url"]]];
        _profileImage = [UIImage imageWithData:imageData];
    }
    return _profileImage;
}

- (NSString*) username
{
    if (_username == nil)
        _username = [@"@" stringByAppendingString:[self.data valueForKeyPath:@"user.screen_name"]];
    return _username;
}

- (NSString*) bodyText
{
    if (_bodyText == nil)
        _bodyText = [self.data valueForKey:@"text"];
    return _bodyText;
}

- (NSString*) idString
{
    if (_idString == nil)
        _idString = [self.data valueForKey:@"id_str"];
    return _idString;
}

- (NSDate*) dateCreated
{
    if (_dateCreated == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss z yyyy"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
        _dateCreated = [dateFormatter dateFromString:[self.data valueForKey:@"created_at"]];
    }
    return _dateCreated;
}

- (id) initWithTweetData:(NSArray*) tweetData
{
    if (self = [super init]){
        _data = tweetData;
    }
    return self;
}

- (NSInteger) compareDate:(MGTweetItem*)tweetItem
{
    return [self.dateCreated compare:tweetItem.dateCreated];
}

@end
