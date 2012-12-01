//
//  MGTimelineManager.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTimelineManager.h"
#import "MGTweetItem.h"
#import "NSArray+Search.h"

@interface MGTimelineManager () {
    int twitterIDsBeingFetched;
}
@end

@implementation MGTimelineManager

@synthesize timelineParser = _timelineParser, tweets = _tweets, delegate = _delegate, timelines = _timelines, profilePictures = _profilePictures, usernamesDictionary = _usernamesDictionary;

- (NSMutableDictionary*) timelines {
    if (!_timelines)
        _timelines = [[NSMutableDictionary alloc] init];
    return _timelines;
}

- (NSArray*) allUsernames {
    return [self.usernamesDictionary allValues];
}

- (NSMutableDictionary*) usernamesDictionary {
    if (!_usernamesDictionary)
        _usernamesDictionary = [[NSMutableDictionary alloc] init];
    return _usernamesDictionary;
}

- (NSMutableDictionary*) profilePictures {
    if (!_profilePictures)
        _profilePictures = [[NSMutableDictionary alloc] init];
    return _profilePictures;
}

- (NSMutableArray*) tweets {
    if (!_tweets)
        _tweets = [[NSMutableArray alloc] init];
    return _tweets;
}

- (id) initWithTwitterIDs:(NSArray*)twitterIDs
{
    if (self = [super init]) {
        _timelineParser = [[MGTimelineParser alloc] initWithTwitterIDs:twitterIDs];
        _timelineParser.delegate = self;
        
        //act as if every twitter account is loaded
        //makes sense if you look at fetchTimelines logic
        NSMutableArray *yesArray = [NSMutableArray array];
        for (int i = 0 ; i < twitterIDs.count; i++)
            [yesArray addObject:[NSNumber numberWithBool:YES]];
        timelinesLoaded = [[NSMutableDictionary alloc] initWithObjects:yesArray forKeys:twitterIDs];
    }
    return self;
}

- (void)sortTweetsWithNewTimeline:(NSArray*)newTimeline forTwitterID:(NSString*)twitterID
{
    if (!newTimeline)
        return;
    
    NSMutableArray *newTweets = [NSMutableArray array];
    for (NSArray *tweetData in newTimeline) {
        MGTweetItem *tweet = [[MGTweetItem alloc] initWithTweetData:tweetData];
        [newTweets addObject:tweet];
        
        //add new usernames to dictionary
        if ([[self.usernamesDictionary allKeys] count] < [self.timelineParser.twitterIDs count] &&
            [self.usernamesDictionary objectForKey:tweet.userID] == nil) {
            if (tweet.username != nil) {
                [self.usernamesDictionary setObject:tweet.username forKey:twitterID];
                NSLog(@"Adding Username - %@",tweet.username);
            }
        }
        
        //only set/load profile pictures once
        if ([self.profilePictures objectForKey:twitterID] == nil && tweet.profileImage != nil) {
            [self.profilePictures setObject:tweet.profileImage forKey:twitterID];
        }
    }
    
    NSArray *sortByDate = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]];
    [newTweets sortUsingDescriptors:sortByDate];
    
    //set that we loaded this twitterID
    [timelinesLoaded setObject:[NSNumber numberWithBool:YES] forKey:twitterID];
    
    if ([self.timelines objectForKey:twitterID]) {
        //only keep new tweets! - remove old ones
        NSDate *mostRecentTweet = ((MGTweetItem*)[[self.timelines objectForKey:twitterID] objectAtIndex:0]).dateCreated;
        NSUInteger indexOfDate = [newTweets binarySearchForDate:mostRecentTweet];
        if (indexOfDate == 0) {
            [newTweets removeAllObjects];
        }
        else if (indexOfDate != NSNotFound) {
            [newTweets removeObjectsInRange:NSMakeRange(indexOfDate, newTweets.count-indexOfDate)];
            //add new timeline data to old timeline data
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newTweets.count)];
            [[self.timelines objectForKey:twitterID] insertObjects:newTweets atIndexes:indexSet];
        }
    }else {
        //no set timeline for twitter id yet so add all tweets
        [self.timelines setObject:newTweets forKey:twitterID];
    }
    
    //add new tweets and sort
    [self.tweets addObjectsFromArray:newTweets];
    [self.tweets sortUsingDescriptors:sortByDate];
    
    //send new, sorted timeline to delegate
    if ([self.delegate respondsToSelector:@selector(timelineManagerLoadedNewTweets:forTwitterID:)]) {
        if (newTweets.count > 0) //checks for new tweets
            [self.delegate timelineManagerLoadedNewTweets:newTweets forTwitterID:twitterID];
        else //no new tweets - send nil
            [self.delegate timelineManagerLoadedNewTweets:nil forTwitterID:twitterID];
    }
    
    //checks to see if all feeds have been loaded
    int i = self.timelineParser.twitterIDs.count; //should be 0 when all loaded
    for (NSString *key in [timelinesLoaded allKeys]) {
        if ([[timelinesLoaded objectForKey:key] boolValue])
            i--;
    }
    //all feeds are loaded - send to delegate
    if (i == 0 && [self.delegate respondsToSelector:@selector(timelineManagerLoadedNewTimelines:)]) {
        [self.delegate timelineManagerLoadedNewTimelines:self.timelines];
    }
}

- (void) loadSavedTimelinesForTwitterIDs:(NSArray*)twitterIDs {
    //only load those that are not being loaded currently -- rare case
    //only time it wouldn't load all saved timelines would if you called fetchTimelines
    //and then called loadSavedTimelinesForTwitterIDs:
    NSMutableArray *twitterIDsToLoad = [NSMutableArray array];
    for (NSString *twitterID in twitterIDs) {
        BOOL alreadyLoaded = [[timelinesLoaded objectForKey:twitterID] boolValue];
        if (alreadyLoaded) {
            [timelinesLoaded setObject:[NSNumber numberWithBool:NO] forKey:twitterID];
            [twitterIDsToLoad addObject:twitterID];
        }
    }
    
    for (NSString *twitterID in twitterIDs)
        [self sortTweetsWithNewTimeline:[MGTimelineSaveUtil loadTimelineForTwitterID:twitterID] forTwitterID:twitterID];
}

- (void) fetchTimelines
{
    //only set those that have been loaded
    //don't want to load those that havent been loaded twice!
    NSMutableArray *twitterIDsToLoad = [NSMutableArray array];
    for (NSString *key in [timelinesLoaded allKeys]) {
        BOOL alreadyLoaded = [[timelinesLoaded objectForKey:key] boolValue];
        if (alreadyLoaded) {
            [timelinesLoaded setObject:[NSNumber numberWithBool:NO] forKey:key];
            [twitterIDsToLoad addObject:key];
        }
    }
    
    //only load those twitter IDs that have already been loaded before
    //will load all twitterIDs if everyone has been loaded before or on first fetch
    [self.timelineParser fetchTimelinesForTwitterIDs:twitterIDsToLoad];
}

#pragma mark - MGTimelineParserDelegate methods
- (void) timelineParsingComplete:(NSArray *)timeline forTwitterID:(NSString *)twitterID
{
    [self sortTweetsWithNewTimeline:timeline forTwitterID:twitterID];
    
    if ([self.delegate respondsToSelector:@selector(timelineManagerLoadedJSONTimeline:forTwitterID:)]) {
        [self.delegate timelineManagerLoadedJSONTimeline:timeline forTwitterID:twitterID];
    }
}

-(void) timelineConnectionError
{
    if ([self.delegate respondsToSelector:@selector(timelineManagerConnectionError:)])
        [self.delegate timelineManagerConnectionError:self];
}

-(void) timelineFetchErrorForTwitterID:(NSString *)twitterID
{
    if ([self.delegate respondsToSelector:@selector(timelineManagerErrorLoadingTimelineForTwitterID:)])
        [self.delegate timelineManagerErrorLoadingTimelineForTwitterID:twitterID];
}



@end
