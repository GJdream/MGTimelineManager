//
//  MGTimelineManager.h
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "MGTimelineParser.h"

@interface MGTimelineController : UIViewController <MGTimelineParserDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    IBOutlet UITableView *tableView;
}

//repsonsable for the actual timeline fetching/parsing
@property (nonatomic) MGTimelineParser *timelineParser;

//key = twitterID (user id)
//value = username
@property (nonatomic) NSMutableDictionary *usernamesDictionary;

//holds all MGTweetItems that have a twitterID listed in "twitterIDs" method
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *timelineManagedObjectContext;

//helper method that calls fetchTimelines in MGTimelineParser
- (void) fetchTimelines;

//returns all objects from usernamesDictionary which are all the usernames
- (NSArray*) allUsernames;

//MUST BE OVERRIDDEN!!!!
//check out http://www.idfromuser.com/ for twitterIDs
- (NSArray*) twitterIDs;

//override to handle errors
//currently do nothing but log info
-(void) timelineConnectionError;
-(void) timelineFetchErrorForTwitterID:(NSString *)twitterID;

@end
