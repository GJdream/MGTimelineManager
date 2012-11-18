# MGTimelineManager
- MGTimelineManager is a simple twitter timeline manager for iOS.

MGTimelineManager uses AFNetworking and SBJson for parsing and fetching timelines. Tweets are stored in MGTweetItems.

## Setup
- Add the "MGTimelineManager" folder to your project (The nest MGTimelineManager folder)
- Add SystemConfiguration.framework to your project

## Example Usage

Check the demo for full code and visual example

```objc
#import "MGTimelineManager.h"

//twitter ids are more stable for use
//head to http://www.idfromuser.com/ to lookup twitter IDs!
MGTimelineManager *timelineManager = [[MGTimelineManager alloc] initWithTwitterIDs:[NSArray arrayWithObjects:@"63400533", @"486599947", nil]];
timelineManager = self;
[timelineManager fetchTimelines];
```

Here is an example usage of MGTimelineManagerDelegate Methods
```objc
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
```
Checkout the demo project for a full example.