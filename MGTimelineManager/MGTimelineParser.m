//
//  MGTimelineParser.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTimelineParser.h"
#import "Reachability.h"
#import "AFJSONRequestOperation+Twitter.h"
#import "MGTweetItem.h"

@implementation MGTimelineParser

@synthesize usernames = _usernames, isReachable, timeout = _timeout, twitterIDs = _twitterIDs, delegate = _delegate, usernamesDictionary = _usernamesDictionary;

- (NSMutableArray*) usernames {
    if (!_usernames)
        _usernames = [[NSMutableArray alloc] init];
    return _usernames;
}

- (NSMutableDictionary*) usernamesDictionary {
    if (!_usernamesDictionary)
        _usernamesDictionary = [[NSMutableDictionary alloc] init];
    return _usernamesDictionary;
}

- (id) initWithTwitterIDs:(NSArray *)twitterIDs
{
    if (self = [super init]) {
        _twitterIDs = twitterIDs;
        _timeout = 60.0f;
    }
    return self;
}

-(BOOL)isReachable
{
    Reachability *reach = [Reachability reachabilityWithHostname:@"api.twitter.com"];
    if([reach currentReachabilityStatus] == NotReachable)
        return NO;
    return YES;
}

- (void) fetchTimelines {
    [self fetchTimelinesForTwitterIDs:self.twitterIDs];
}

-(void) fetchTimelinesForTwitterIDs:(NSArray*)twitterIDs
{
    if(self.isReachable) {
        for (NSString *twitterID in twitterIDs)
        {
            AFJSONRequestOperation *operation = [AFJSONRequestOperation twitterJSONRequestOperationWithTwitterID:twitterID timeoutInterval:self.timeout success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSData *responseData) {
                [self loadTimeline:JSON forTwitterID:twitterID];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON, NSData *responseData) {
                [self.delegate timelineFetchErrorForTwitterID:twitterID];
            }];
            
            [operation start];
        }
    }
    else {
        NSLog(@"No internet connection - Timelines cannot be loaded");
        [self.delegate timelineConnectionError];
    }
    
}

#pragma mark - Saving & Loading timeline data
//checks if timeline is valid and can be used
- (BOOL) isTimelineValid:(NSArray*)timeline
{
    if ([timeline containsObject:[timeline valueForKey:@"error"]] || timeline == nil)
        return NO;
    return YES;
}

- (void) loadTimeline:(NSArray*)timeline forTwitterID:(NSString*)twitterID
{
    if ([self isTimelineValid:timeline]) {        
        //sets NEW usernames
        //could be bad if you add twitterIDs or remove them after being set
        if ([self.usernames count] < [self.twitterIDs count]) {
            for (NSArray *tweetData in timeline) {
                MGTweetItem *tweet = [[MGTweetItem alloc] initWithTweetData:tweetData];
                if (tweet.username != nil) {
                    [self.usernames addObject:tweet.username];
                    [self.usernamesDictionary setObject:tweet.username forKey:twitterID];
                    break;
                }
            }
        }
                        
        //send fetched timline to delgate
        if ([self.delegate respondsToSelector:@selector(timelineParsingComplete:forTwitterID:)])
            [self.delegate timelineParsingComplete:timeline forTwitterID:twitterID];
    }
    else {
        [self timelineFetchErrorForID:twitterID];
    }
    
}

- (void) timelineFetchErrorForID:(NSString*)twitterID
{
    NSLog(@"Timeline Fetch Error for id - %@",twitterID);
    if ([self.delegate respondsToSelector:@selector(timelineFetchErrorForTwitterID:)]){
        [self.delegate timelineFetchErrorForTwitterID:twitterID];
    }
}

@end
