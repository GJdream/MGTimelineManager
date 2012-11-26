//
//  MGViewController.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGViewController.h"
#import "MGTweetItem.h"
#import "MGTweetCell.h"

@interface MGViewController ()
{
    IBOutlet UITableView *tableView;
    
    MGTimelineManager *timelineManager;
    int amountNewTweets;
    
    dispatch_queue_t feedFetchQueue;
}

- (IBAction)refreshButtonPressed:(id)sender;

@end

@implementation MGViewController

- (NSArray*) twitterIDs {
    return [NSArray arrayWithObjects:@"63400533", @"486599947", @"745904089", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    feedFetchQueue = dispatch_queue_create("com.mglagola.HFHS.FeedFetchQueue", NULL);
    
    //twitter ids are more stable b/c twitter usernames can change, ids cannot
    //head to http://www.idfromuser.com/ to lookup twitter IDs!
    timelineManager = [[MGTimelineManager alloc] initWithTwitterIDs:[self twitterIDs]];
    timelineManager.delegate = self;
    
    //load saved timelines on startup so we don't have to fetch data
    if ([MGTimelineSaveUtil amountOfTimelinesSavedForTwitterIDs:[self twitterIDs]] > 0) {
        [self loadSavedTimelines];
    }else {
        //no saved timelines - load from twitter
        [self refreshButtonPressed:nil];
    }
    
}

- (void) loadSavedTimelines
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    amountNewTweets = 0;
    [timelineManager loadSavedTimelinesForTwitterIDs:[self twitterIDs]];
}

- (IBAction)refreshButtonPressed:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    amountNewTweets = 0;
    [timelineManager fetchTimelines];
}

#pragma mark - TableView delegate Methods

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    MGTweetCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MGTweetCell alloc] initWithNib];
    }
    
    MGTweetItem *item = [timelineManager.tweets objectAtIndex:indexPath.row];
    cell.tweetItem = item;
    cell.profileImageView.image = [timelineManager.profilePictures objectForKey:item.userID];
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    return [timelineManager.tweets count];
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// probably slower loading new cell but flexable
    MGTweetCell *tempCell = ((MGTweetCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath]);
    tempCell.tweetItem = [timelineManager.tweets objectAtIndex:indexPath.row];
    return tempCell.height;
}

#pragma mark - MGTimelineManagerDelegate methods

- (void) timelineManagerLoadedNewTweets:(NSArray *)newTweets forTwitterID:(NSString *)twitterID {
    amountNewTweets += newTweets.count;
}

- (void) timelineManagerLoadedNewTimelines:(NSDictionary *)timelines {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSMutableArray *newTweetsIndexes = [NSMutableArray array];
    for (int i = 0; i < amountNewTweets; i ++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        [newTweetsIndexes addObject:path];
    }
    [tableView insertRowsAtIndexPaths:newTweetsIndexes withRowAnimation:UITableViewRowAnimationFade];
}

//save raw json timelines using MGTimelineSaveUtil
//good for loading saved timelines on starup for example (see viewDidLoad)
- (void) timelineManagerLoadedJSONTimeline:(NSArray*)jsonTimeline forTwitterID:(NSString*)twitterID {
    [MGTimelineSaveUtil saveTimeline:jsonTimeline forTwitterID:twitterID];
}

- (void) timelineManagerConnectionError:(MGTimelineManager *)timelineManager
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not connect to twitter" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

- (void) timelineManagerErrorLoadingTimelineForTwitterID:(NSString *)twitterID
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *message = [NSString stringWithFormat:@"Could not load twitter id - %@",twitterID];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

@end
