//
//  MGTimelineSaverUtil.m
//  HFHS
//
//  Created by Mark Glagola on 11/25/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTimelineSaveUtil.h"

@implementation MGTimelineSaveUtil

+ (NSString*) directoryPathForTwitterID:(NSString*)twitterID {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [NSString stringWithFormat:@"%@/%@.plist",docDir,twitterID];
}

+ (void) saveTimeline:(NSArray*)timeline forTwitterID:(NSString*)twitterID {
    [NSKeyedArchiver archiveRootObject:timeline toFile:[self directoryPathForTwitterID:twitterID]];
}

+ (NSArray*) loadTimelineForTwitterID:(NSString*)twitterID {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self directoryPathForTwitterID:twitterID]];
}

+ (int) amountOfTimelinesSavedForTwitterIDs:(NSArray*)twitterIDs {
    int amount = 0;
    for (NSString *twitterID in twitterIDs) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self directoryPathForTwitterID:twitterID]])
            amount++;
    }
    return amount;
}

@end
