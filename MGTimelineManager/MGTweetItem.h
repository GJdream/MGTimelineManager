//
//  MGTweetItem.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGTweetItem : NSObject

@property (nonatomic) NSDate *dateCreated;
@property (nonatomic) NSArray *data;
@property (nonatomic) UIImage *profileImage;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *bodyText;
@property (nonatomic) NSString *tweetID;
@property (nonatomic) NSString *userID;

//sets data property - the core this object
- (id) initWithTweetData:(NSArray*) tweetData;

@end
