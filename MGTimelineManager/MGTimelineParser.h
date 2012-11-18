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
{
    //stores all fetched timelines in a dictionary
    //keys are twitterIDs
    NSMutableDictionary *timelinesDict;
}

//this is what is used to load timeline data
//use http://www.idfromuser.com/ to look up user ids
//this is much more statble as IDs don't change but usernames can
@property (nonatomic,readonly) NSArray *twitterIDs;

//will be set after loading timeline data
@property (nonatomic, readonly) NSMutableArray *usernames;

//Default is 60.0f
@property (nonatomic) float timeout;

//checks if twitter api can be reached
@property (nonatomic,readonly) BOOL isReachable;

@property (nonatomic) id <MGTimelineParserDelegate> delegate;

//init w/ twitter ID(s)
- (id) initWithTwitterIDs:(NSArray *)twitterIDs;

//starts fetching the timeline(s)
- (void) fetchTimelines;

@end
