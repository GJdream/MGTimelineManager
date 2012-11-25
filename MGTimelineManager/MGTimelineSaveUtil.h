//
//  MGTimelineSaverUtil.h
//  HFHS
//
//  Created by Mark Glagola on 11/25/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

//this class is optional and is not used unless you directly save your timelines
@interface MGTimelineSaveUtil : NSObject

+ (NSString*) directoryPathForTwitterID:(NSString*)twitterID;

+ (void) saveTimeline:(NSArray*)timeline forTwitterID:(NSString*)twitterID;

+ (NSArray*) loadTimelineForTwitterID:(NSString*)twitterID;

+ (int) amountOfTimelinesSavedForTwitterIDs:(NSArray*)twitterIDs;

@end
