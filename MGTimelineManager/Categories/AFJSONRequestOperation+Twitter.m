//
//  AFJSONRequestOperation+Twitter.m
//  bruncon
//
//  Created by Mark Glagola on 10/10/12.
//  Copyright (c) 2012 Sanders New Media. All rights reserved.
//

#import "AFJSONRequestOperation+Twitter.h"

@implementation AFJSONRequestOperation (Twitter)

+ (AFJSONRequestOperation *) twitterJSONRequestOperationWithTwitterID:(NSString *)twitterID
                                                         timeoutInterval:(NSTimeInterval)timeoutInterval
                                                                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSData *responseData))success
                                                                 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON, NSData *responseData))failure
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.twitter.com/1/statuses/user_timeline.json?user_id=%@", [twitterID stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:timeoutInterval];
    
    
    AFJSONRequestOperation *requestOperation = [[self alloc] initWithRequest:request];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation.request, operation.response, responseObject, operation.responseData);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation.request, operation.response, error, [(AFJSONRequestOperation *)operation responseJSON], operation.responseData);
        }
    }];
    
    return requestOperation;
    
}

@end
