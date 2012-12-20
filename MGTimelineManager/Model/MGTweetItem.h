//
//  MGTweetItem.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 12/16/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MGProfilePicture;

@interface MGTweetItem : NSManagedObject

@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * bodyText;
@property (nonatomic, retain) NSString * tweetID;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) MGProfilePicture *profilePicture;

+ (MGTweetItem*) tweetItemWithJSONData:(NSArray*)data inManagedObjectContext:(NSManagedObjectContext*)context;

@end
