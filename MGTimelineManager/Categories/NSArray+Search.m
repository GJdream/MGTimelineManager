//
//  NSArray+Search.m
//  HFHS
//
//  Created by Mark Glagola on 11/20/12.
//  Copyright (c) 2012 Mark Glagola. All rights reserved.
//

#import "NSArray+Search.h"
#import "MGTweetItem.h"

@implementation NSArray (Search)

- (NSUInteger) binarySearchForDate:(NSDate*)searchDate
{
    if (searchDate == nil || ![searchDate isKindOfClass:[NSDate class]])
        return NSNotFound;
    return [self binarySearchForDate:searchDate minIndex:0 maxIndex:[self count] - 1];
}

- (NSUInteger) binarySearchForDate:(NSDate*)searchDate minIndex:(NSInteger)minIndex maxIndex:(NSInteger)maxIndex
{
    if (maxIndex < minIndex)
        return NSNotFound;
    
    NSInteger midIndex = (minIndex + maxIndex) / 2;
    MGTweetItem  *itemAtMidIndex = (MGTweetItem*)[self objectAtIndex:midIndex];
    
    NSComparisonResult comparison = [searchDate compare:itemAtMidIndex.dateCreated];
    if (comparison == NSOrderedSame)
        return midIndex;
    else if (comparison == NSOrderedAscending)
        return [self binarySearchForDate:searchDate minIndex:minIndex maxIndex:midIndex - 1];
    else
        return [self binarySearchForDate:searchDate minIndex:midIndex + 1 maxIndex:maxIndex];
}


@end
