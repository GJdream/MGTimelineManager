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

- (IBAction)refreshButtonPressed:(id)sender;

@end

@implementation MGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //twitter ids are more stable b/c twitter usernames can change, ids cannot
    //head to http://www.idfromuser.com/ to lookup twitter IDs!
    manager = [[MGTimelineManager alloc] initWithTwitterIDs:[NSArray arrayWithObjects:@"63400533", @"486599947", nil]];
    manager.delegate = self;
    [self refreshButtonPressed:nil];
}

- (IBAction)refreshButtonPressed:(id)sender {
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
- (void) timelineManagerLoadedNewTimelines:(NSDictionary *)timelines
{
    [tableView reloadData];
}

//timeline will be nil if no new tweets were found
- (void) timelineManagerLoadedNewTimeline:(NSArray *)timeline forTwitterID:(NSString *)twitterID
{
    
    NSLog(@"Timeline loaded for id - %@",twitterID);
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
