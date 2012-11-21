//
//  MGTimelineManager.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTimelineManager.h"
#import "MGTweetItem.h"

@implementation MGTimelineManager

@synthesize timelineParser = _timelineParser, tweets = _tweets, delegate = _delegate, recentlyFetchedTweets = _recentlyFetchedTweets;

- (void)sortTweetsWithNewTimeline:(NSArray*)newTimeline
{
    NSMutableArray *newTweets = [NSMutableArray array];
    for (NSArray *tweetData in newTimeline) {
        MGTweetItem *tweet = [[MGTweetItem alloc] initWithTweetData:tweetData];
        [newTweets addObject:tweet];
    }
    
    [self.tweets addObjectsFromArray:newTweets];
    self.recentlyFetchedTweets = [[NSMutableArray alloc] initWithArray:newTweets];
    
    //sorts by date
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:NO]];
    [self.tweets sortUsingDescriptors:sortDescriptors];
    [self.recentlyFetchedTweets sortUsingDescriptors:sortDescriptors];

    [self.delegate timelineManagerLoadedNewTimeline:self];
}

- (id) initWithTwitterIDs:(NSArray*)twitterIDs
{
    if (self = [super init]) {
        _timelineParser = [[MGTimelineParser alloc] initWithTwitterIDs:twitterIDs];
        _timelineParser.delegate = self;
        _tweets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) fetchTimelines
{
    [self.timelineParser fetchTimelines];
}

#pragma mark - MGTimelineParserDelegate methods
- (void) timelineParsingComplete:(NSArray *)timeline forTwitterID:(NSString *)twitterID
{
    [self sortTweetsWithNewTimeline:timeline];
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
