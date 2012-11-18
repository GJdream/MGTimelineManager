//
//  MGViewController.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGViewController.h"
#import "MGTweetItem.h"

@interface MGViewController ()
{
    MGTimelineManager *manager;
    IBOutlet UITableView *tableView;
}

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //twitter ids are more stable for use
    //head to http://www.idfromuser.com/ to lookup twitter IDs!
    manager = [[MGTimelineManager alloc] initWithTwitterIDs:[NSArray arrayWithObjects:@"63400533", @"486599947", nil]];
    manager.delegate = self;
    [manager fetchTimelines];
}

#pragma mark - TableView delegate Methods

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BCTweetCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    MGTweetItem *tweet = [manager.tweets objectAtIndex:indexPath.row];
    cell.textLabel.text = tweet.bodyText;
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section {
    return [manager.tweets count];
}

#pragma mark - MGTimelineManagerDelegate methods
- (void) timelineManagerLoadedNewTimeline:(MGTimelineManager *)timelineManager
{
    [tableView reloadData];
}

- (void) timelineManagerConnectionError:(MGTimelineManager *)timelineManager
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Could not connect to twitter" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

- (void) timelineManagerErrorLoadingTimelineForTwitterID:(NSString *)twitterID
{
    NSString *message = [NSString stringWithFormat:@"Could not load twitter id - %@",twitterID];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:message delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}

@end
