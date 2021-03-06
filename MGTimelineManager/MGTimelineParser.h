//
//  MGTimelineParser.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGTimelineParserDelegate <NSObject>
@optional
- (void)timelineParsingComplete:(NSArray*)timeline forTwitterID:(NSString*)twitterID;
- (void)timelineFetchErrorForTwitterID:(NSString*)twitterID;
- (void)timelineConnectionError;
@end

@interface MGTimelineParser : NSObject
//this is what is used to load timeline data
//use http://www.idfromuser.com/ to look up user ids
//this is much more statble as IDs don't change but usernames can
@property (nonatomic,readonly) NSArray *twitterIDs;

//Default is 60.0f
@property (nonatomic) float timeout;

//checks if twitter api can be reached
@property (nonatomic,readonly) BOOL isReachable;

@property (nonatomic) id <MGTimelineParserDelegate> delegate;

//init w/ twitter ID(s)
- (id) initWithTwitterIDs:(NSArray *)twitterIDs;

//starts fetching all the timeline(s) for each twitterID
- (void) fetchTimelines;

//should not use this directly - fetch timelines through MGTimelineMangager
-(void) fetchTimelinesForTwitterIDs:(NSArray*)twitterIDs;

@end
