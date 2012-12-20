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
#import "MGProfilePicture.h"
#import "AsyncImageView.h"

@interface MGViewController () {
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
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"MGTweetItem" inManagedObjectContext:self.timelineManagedObjectContext];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateCreated" ascending:YES]];
    request.predicate = nil;//[NSPredicate predicateWithFormat:@"userID IN %@",self.twitterIDs];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.timelineManagedObjectContext sectionNameKeyPath:nil cacheName:@"MGTweetItemCache"];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    NSLog(@"Error - %@", [error userInfo]);
    
    [self fetchTimelines];
}

- (void) dealloc {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    dispatch_release(feedFetchQueue);
#endif
}

- (IBAction)refreshButtonPressed:(id)sender
{
    dispatch_async(feedFetchQueue, ^{
        [self fetchTimelines];
    });
}

#pragma mark - TableView delegate Methods

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TweetCell";
    MGTweetCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MGTweetCell alloc] initWithNib];
        cell.profileImageView.showActivityIndicator = NO;
        cell.profileImageView.crossfadeImages = NO;
    }
    
    MGTweetItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.tweetItem = item;
    NSLog(@"Path: %@", item.profilePicture.path);
    cell.profileImageView.imageURL = [NSURL URLWithString:item.profilePicture.path];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// probably slower loading new cell but flexable
    MGTweetCell *tempCell = ((MGTweetCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath]);
    tempCell.tweetItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return tempCell.height;
}

- (void) timelineConnectionError
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
