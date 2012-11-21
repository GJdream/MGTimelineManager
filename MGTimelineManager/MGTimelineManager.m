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

@synthesize timelineParser = _timelineParser, tweets = _tweets, delegate = _delegate, timelines = _timelines;

- (void)sortTweetsWithNewTimeline:(NSArray*)newTimeline forTwitterID:(NSString*)twitterID
{
    NSMutableArray *newTweets = [NSMutableArray array];
    for (NSArray *tweetData in newTimeline) {
        MGTweetItem *tweet = [[MGTweetItem alloc] initWithTweetData:tweetData];
        [newTweets addObject:tweet];
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
            [[self.timelines objectForKey:twitterID] addObjectsFromArray:newTweets];
        }
    }else {
        //no set timeline for twitter id yet so add all tweets
        [self.timelines setObject:newTweets forKey:twitterID];
    }
    
    //add new tweets and sort
    [self.tweets addObjectsFromArray:newTweets];
    [self.tweets sortUsingDescriptors:sortByDate];
    
    //send new, sorted timeline to delegate
    if ([self.delegate respondsToSelector:@selector(timelineManagerLoadedNewTimeline:forTwitterID:)]) {
        if (newTweets.count > 0) //checks for new tweets
            [self.delegate timelineManagerLoadedNewTimeline:newTweets forTwitterID:twitterID];
        else //no new tweets - send nil
            [self.delegate timelineManagerLoadedNewTimeline:nil forTwitterID:twitterID];
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

- (id) initWithTwitterIDs:(NSArray*)twitterIDs
{
    if (self = [super init]) {
        _timelineParser = [[MGTimelineParser alloc] initWithTwitterIDs:twitterIDs];
        _timelineParser.delegate = self;
        _tweets = [[NSMutableArray alloc] init];
        _timelines = [[NSMutableDictionary alloc] init];
        
        //act as if every twitter account is loaded
        //makes sense if you look at fetchTimelines logic
        NSMutableArray *yesArray = [NSMutableArray array];
        for (int i = 0 ; i < twitterIDs.count; i++)
            [yesArray addObject:[NSNumber numberWithBool:YES]];
        timelinesLoaded = [[NSMutableDictionary alloc] initWithObjects:yesArray forKeys:twitterIDs];
    }
    return self;
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
