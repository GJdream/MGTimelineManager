#No Longer Maintained (as of now)

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

//twitter ids are more stable b/c twitter usernames can change, ids cannot
//head to http://www.idfromuser.com/ to lookup twitter IDs!
MGTimelineManager *timelineManager = [[MGTimelineManager alloc] initWithTwitterIDs:[NSArray arrayWithObjects:@"63400533", @"486599947", nil]];
timelineManager = self;
[timelineManager fetchTimelines];
```

Here is an example usage of MGTimelineManagerDelegate Methods
```objc
#pragma mark - MGTimelineManagerDelegate methods
- (void) timelineManagerLoadedNewTimelines:(NSDictionary *)timelines
{
    [tableView reloadData];
}

//timeline will be nil if no new tweets were found
- (void) timelineManagerLoadedNewTweets:(NSArray *)timeline forTwitterID:(NSString *)twitterID
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

//OPTIONAL
//Use MGTimelineSaveUtil to save json timelines
//could be useful to load up saved timelines instead of loading new timelines on every startup 
- (void) timelineManagerLoadedJSONTimeline:(NSArray*)jsonTimeline forTwitterID:(NSString*)twitterID {
    [MGTimelineSaveUtil saveTimeline:jsonTimeline forTwitterID:twitterID];
}
```

OPTIONAL
You can also load up saved timelines from the MGTimelineSaveUtil if you have any saved json timelines (See timelineManagerLoadedJSONTimeline: delegate method for saving json timelines)
```objc
    //makes sure there is at least one timeline saved
    if ([MGTimelineSaveUtil amountOfTimelinesSavedForTwitterIDs:[self twitterIDs]] > 0) {
        [timelineManager loadSavedTimelinesForTwitterIDs:[self twitterIDs]];
    }else {
        [timelineManager fetchTimelines];
    }

```

### Other
- Check out the demo!
- Let me know if you use MGTimelineManager in your app!
