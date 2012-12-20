//
//  MGTweetItem.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTweetItem.h"

@implementation MGTweetItem

@synthesize dateCreated = _dateCreated, data = _data, profileImage = _profileImage, username = _username, bodyText = _bodyText, tweetID = _tweetID, userID = _userID, profileImageURL = _profileImageURL;

- (UIImage*) profileImage
{
    if (_profileImage == nil) {
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.profileImageURL]];
        _profileImage = [UIImage imageWithData:imageData];
    }
    return _profileImage;
}

- (NSString*) profileImageURL {
    if (_profileImageURL == nil)
        _profileImageURL = [self.data valueForKeyPath:@"user.profile_image_url"];
    return _profileImageURL;
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

- (NSString*) tweetID
{
    if (_tweetID == nil)
        _tweetID = [self.data valueForKey:@"id_str"];
    return _tweetID;
}

- (NSString*) userID
{
    if (_userID == nil)
        _userID = [self.data valueForKeyPath:@"user.id_str"];
    return _userID;
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

@end
