//
//  MGProfilePicture.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 12/16/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MGProfilePicture : NSManagedObject

@property (nonatomic, retain) NSString *path;
@property (nonatomic, retain) NSSet *tweetItem;

+ (MGProfilePicture*) profilePictureForPath:(NSString*)path inManagedContext:(NSManagedObjectContext*)context;

@end

@interface MGProfilePicture (CoreDataGeneratedAccessors)

- (void)addTweetItemObject:(NSManagedObject *)value;
- (void)removeTweetItemObject:(NSManagedObject *)value;
- (void)addTweetItem:(NSSet *)values;
- (void)removeTweetItem:(NSSet *)values;

@end
