//
//  MGTweetCell.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/25/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTweetCell.h"
#import "MGTweetItem.h"
#import "NSDate+Readable.h"

@implementation MGTweetCell

@synthesize tweetItem = _tweetItem, height = _height;

- (id) initWithNib
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return [topLevelObjects objectAtIndex:0];
}

- (void) setTweetItem:(MGTweetItem *)tweetItem
{
    self.titleLabel.text = tweetItem.username;
    self.bodyLabel.text = tweetItem.bodyText;
    self.dateLabel.text = [tweetItem.dateCreated readableString];
    _tweetItem = tweetItem;
    
    [self autoresize];
}

- (void) autoresize
{
    //resize bodylabel to fix tweet
    CGRect frame = self.bodyLabel.frame;
    CGSize tweetSize = [self.bodyLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.bodyLabel.frame.size.width, CGFLOAT_MAX)];
    frame.size = tweetSize;
    self.bodyLabel.frame = frame;
    
    //then set the date to be below the new messagelabel frame
    frame = self.dateLabel.frame;
    frame.origin = CGPointMake(frame.origin.x,self.bodyLabel.frame.origin.y+self.bodyLabel.frame.size.height+self.dateLabel.font.pointSize);
    self.dateLabel.frame = frame;
    
    _height = frame.origin.y + frame.size.height*1.1;
}

@end
