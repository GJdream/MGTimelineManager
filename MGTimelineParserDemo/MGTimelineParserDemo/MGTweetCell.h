//
//  MGTweetCell.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/25/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MGTweetItem, AsyncImageView;

@interface MGTweetCell : UITableViewCell

@property (nonatomic) MGTweetItem *tweetItem;

@property (nonatomic,readonly) IBOutlet UILabel *titleLabel;
@property (nonatomic,readonly) IBOutlet UILabel *bodyLabel;
@property (nonatomic,readonly) IBOutlet UILabel *dateLabel;
@property (nonatomic,readonly) IBOutlet AsyncImageView *profileImageView;

//the cells resized height
@property (nonatomic, readonly) int height;

- (id) initWithNib;

@end
