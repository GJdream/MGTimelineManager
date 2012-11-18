//
//  MGTimelineManager.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTimelineParser.h"

@class MGTimelineManager;

@protocol MGTimelineManagerDelegate <NSObject>
@required
- (void) timelineManagerLoadedNewTimeline:(MGTimelineManager*)timelineManager;
@optional
- (void) timelineManagerConnectionError:(MGTimelineManager*)timelineManager;
- (void) timelineManagerErrorLoadingTimelineForTwitterID:(NSString*)twitterID;
@end

@interface MGTimelineManager : NSObject <MGTimelineParserDelegate>
{
}

//repsonsable for the actual timeline fetching/parsing
@property (nonatomic) MGTimelineParser *timelineParser;

//stores all tweets fetched
@property (nonatomic) NSMutableArray *tweets;


@property (nonatomic) id <MGTimelineManagerDelegate> delegate;

//pass in twitter ID's to be fetched later
//see MGTimelineParser for more details
- (id) initWithTwitterIDs:(NSArray*)twitterIDs;

//helper method that calls fetchTimelines in MGTimelineParser
- (void) fetchTimelines;

@end
