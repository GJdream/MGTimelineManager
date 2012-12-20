//
//  MGTimelineManager.m
//  MGTimelineParserDemo
//
//  Created by Mark Glagola on 11/18/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "MGTimelineController.h"
#import "MGTweetItem.h"
#import "MGTimelineParser.h"

@interface MGTimelineController () {
    int twitterIDsBeingFetched;
    NSMutableDictionary *timelinesLoaded;
}

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation MGTimelineController

@synthesize timelineManagedObjectContext = _timelineManagedObjectContext, managedObjectModel = _managedObjectModel, persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize timelineParser = _timelineParser, usernamesDictionary = _usernamesDictionary;

- (NSArray*) allUsernames {
    [self.usernamesDictionary allValues];
    return nil;
}

- (NSArray*) twitterIDs {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in %@", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
    return nil;
}

- (void) initTwitterData {
    _timelineParser = [[MGTimelineParser alloc] initWithTwitterIDs:self.twitterIDs];
    _timelineParser.delegate = self;
    
    NSMutableArray *yesArray = [NSMutableArray array];
    for (int i = 0 ; i < self.twitterIDs.count; i++)
        [yesArray addObject:[NSNumber numberWithBool:YES]];
    timelinesLoaded = [[NSMutableDictionary alloc] initWithObjects:yesArray forKeys:self.twitterIDs];
}

- (id) init
{
    if (self = [super init])
        [self initTwitterData];
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
        [self initTwitterData];
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
        [self initTwitterData];
    return self;
}

- (void)sortTweetsWithNewTimeline:(NSArray*)newTimeline forTwitterID:(NSString*)twitterID
{
    if (!newTimeline) {
        //set that we loaded this twitterID
        [timelinesLoaded setObject:[NSNumber numberWithBool:YES] forKey:twitterID];
        return;
    }
    
    for (NSArray *tweetData in newTimeline) {
        [MGTweetItem tweetItemWithJSONData:tweetData inManagedObjectContext:self.timelineManagedObjectContext];
    }
        
    //set that we loaded this twitterID
    [timelinesLoaded setObject:[NSNumber numberWithBool:YES] forKey:twitterID];
    
    //checks to see if all feeds have been loaded
    int i = self.timelineParser.twitterIDs.count; //should be 0 when all loaded
    for (NSString *key in [timelinesLoaded allKeys]) {
        if ([[timelinesLoaded objectForKey:key] boolValue])
            i--;
    }
    //all feeds are loaded - save tweets for later use!
    if (i == 0) {
        [self saveTimelineContext];
    }
    
}

- (void) fetchTimelines
{
    //only set those that have been loaded and completed already
    //don't want to load those that have yet to give a response and still loading!
    NSMutableArray *twitterIDsToLoad = [NSMutableArray array];
    for (NSString *key in [timelinesLoaded allKeys]) {
        BOOL alreadyLoaded = [[timelinesLoaded objectForKey:key] boolValue];
        if (alreadyLoaded) {
            [timelinesLoaded setObject:[NSNumber numberWithBool:NO] forKey:key];
            [twitterIDsToLoad addObject:key];
        }
    }
    
    //only load those twitter IDs that have already been loaded before
    //will load all twitterIDs if everyone has been loaded before or on first fetch
    [self.timelineParser fetchTimelinesForTwitterIDs:twitterIDsToLoad];
}

#pragma mark - MGTimelineParserDelegate methods
- (void) timelineParsingComplete:(NSArray *)timeline forTwitterID:(NSString *)twitterID {
    [self sortTweetsWithNewTimeline:timeline forTwitterID:twitterID];
}

-(void) timelineConnectionError {
    NSLog(@"Twitter Connection Error");
}

-(void) timelineFetchErrorForTwitterID:(NSString *)twitterID {
    NSLog(@"Twitter Fetch Error loading %@", twitterID);
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - NSFetchedResultsControllerDelegate methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView cellForRowAtIndexPath:indexPath]; //updates only the cell
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [tableView endUpdates];
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *) timelineManagedObjectContext
{
    if (_timelineManagedObjectContext != nil) {
        return _timelineManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _timelineManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_timelineManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _timelineManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MGTimlineManagerModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MGTimlineManagerModel.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void) saveTimelineContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.timelineManagedObjectContext;
    if (managedObjectContext) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
}

@end
