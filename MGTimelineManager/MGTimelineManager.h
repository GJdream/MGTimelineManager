//
//  MGTimelineManager.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGTimelineParser.h"
#import "MGTimelineSaveUtil.h"

@class MGTimelineManager;

@protocol MGTimelineManagerDelegate <NSObject>
@optional
//sends individual timelines that were JUST LOADED --- BRAND NEW tweets only
//"timelines" are full of MGTweetItems
//will send nil if no new timeline data
- (void) timelineManagerLoadedNewTweets:(NSArray*)newTweets forTwitterID:(NSString*)twitterID;

//sends a dictionary w/ timelines linked by their twitter ids
//individual timelines in the timelines dictionary are full of MGTweetItems
- (void) timelineManagerLoadedNewTimelines:(NSDictionary*)timelines;

//sends a raw json timeline fetched from twitter - could be helpful for saving timelines for later use...
//(i.e. on startup load & parse saved json timeline)
- (void) timelineManagerLoadedJSONTimeline:(NSArray*)jsonTimeline forTwitterID:(NSString*)twitterID;

//errors
- (void) timelineManagerConnectionError:(MGTimelineManager*)timelineManager;
- (void) timelineManagerErrorLoadingTimelineForTwitterID:(NSString*)twitterID;
@end

@interface MGTimelineManager : NSObject <MGTimelineParserDelegate>
{    
    //stores whether a twitterID was loaded or not
    //key = twitterID
    //value = NSNumber with bool value
    NSMutableDictionary *timelinesLoaded;
}

//repsonsable for the actual timeline fetching/parsing
@property (nonatomic) MGTimelineParser *timelineParser;

//stores usernames for each twitterID
//key = twitterID
//value = NSString
@property (nonatomic, readonly) NSMutableDictionary *usernamesDictionary;

//stores all tweets fetched
@property (nonatomic) NSMutableArray *tweets;

//stores all of the individual timelines for each twittweetItem.profileImageURLterID
//key = twitterID
//value = NSArray of MGTweets
@property (nonatomic) NSMutableDictionary *timelines;

@property (nonatomic) id <MGTimelineManagerDelegate> delegate;

//pass in twitter ID's to be fetched later
//see MGTimelineParser for more details
- (id) initWithTwitterIDs:(NSArray*)twitterIDs;

//helper method that calls fetchTimelines in MGTimelineParser
- (void) fetchTimelines;

//DO NOT USE unless loading saved timelines
//RECOMMENDED that you call this on startup
- (void) loadSavedTimelinesForTwitterIDs:(NSArray*)twitterIDs;

//returns all objects from usernamesDictionary which are all the usernames
- (NSArray*) allUsernames;

@end
