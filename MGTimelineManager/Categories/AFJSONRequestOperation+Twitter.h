//
//  AFJSONRequestOperation+Twitter.h
//  bruncon
//
//  Created by Mark Glagola on 10/10/12.
//  Copyright (c) 2012 Sanders New Media. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@interface AFJSONRequestOperation (Twitter)

+ (AFJSONRequestOperation *) twitterJSONRequestOperationWithTwitterID:(NSString *)twitterID
                                                      timeoutInterval:(NSTimeInterval)timeoutInterval
                                                              success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON, NSData *responseData))success
                                                              failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON, NSData *responseData))failure;

@end
