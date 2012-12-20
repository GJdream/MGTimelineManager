//
//  MGTweetItem.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 12/16/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTweetItem.h"
#import "MGProfilePicture.h"
#import "NSDate+Convert.h"

@implementation MGTweetItem

@dynamic dateCreated;
@dynamic username;
@dynamic bodyText;
@dynamic tweetID;
@dynamic userID;
@dynamic profilePicture;

+ (MGTweetItem*) tweetItemWithJSONData:(NSArray*)data inManagedObjectContext:(NSManagedObjectContext*)context
{
    NSString *entityName = @"MGTweetItem";
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSPredicate *predicateTweetID = [NSPredicate predicateWithFormat:@"tweetID == %@", [data valueForKey:@"id_str"]];
    NSPredicate *predicateUserID = [NSPredicate predicateWithFormat:@"userID == %@", [data valueForKey:@"user.id_str"]];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicateTweetID, predicateUserID]];
    
    NSError *error = nil;
    MGTweetItem *tweetItem = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (!error && !tweetItem) {
        tweetItem = [NSEntityDescription insertNewObjectForEntityForName:@"MGTweetItem" inManagedObjectContext:context];
        tweetItem.username = [@"@" stringByAppendingString:[data valueForKeyPath:@"user.screen_name"]];
        tweetItem.bodyText = [data valueForKey:@"text"];
        tweetItem.tweetID = [data valueForKey:@"id_str"];
        tweetItem.userID = [data valueForKey:@"user.id_str"];
        tweetItem.dateCreated = [NSDate convertTwitterDate:[data valueForKey:@"created_at"]];
        tweetItem.profilePicture = [MGProfilePicture profilePictureForPath:[data valueForKeyPath:@"user.profile_image_url"] inManagedContext:context];
    }
    
    return tweetItem;
}

@end
