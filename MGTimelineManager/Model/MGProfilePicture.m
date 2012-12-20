//
//  MGProfilePicture.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 12/16/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGProfilePicture.h"


@implementation MGProfilePicture

@dynamic path;
@dynamic tweetItem;

+ (MGProfilePicture*) profilePictureForPath:(NSString*)path inManagedContext:(NSManagedObjectContext*)context
{
    NSLog(@"Path: %@", path);

    NSString *entityName = @"MGProfilePicture";
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"path == %@", path];
    
    NSError *error = nil;
    MGProfilePicture *profilePicture = [[context executeFetchRequest:request error:&error] lastObject];
    
    if (!error && !profilePicture) {
        MGProfilePicture *profilePicture = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        profilePicture.path = path;
    }
    
    return profilePicture;
}

@end
