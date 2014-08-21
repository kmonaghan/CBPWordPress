//
//  CBPWordPressAPIClient.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressAPIClient.h"

#import "CBPWordPressSearchParamters.h"

@implementation CBPWordPressAPIClient
static NSString *rootURI = nil;
+ (instancetype)sharedClient
{
    NSAssert(rootURI != nil, @"No root URL set - [CBPWordPressAPIClient rootURI:<your root URL>] should be called before this method");
    
    static CBPWordPressAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CBPWordPressAPIClient alloc] initWithBaseURL:[NSURL URLWithString:rootURI]];
        [_sharedClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    });
    
    return _sharedClient;
}

+ (void)rootURI:(NSString *)URI
{
    rootURI = URI;
}

- (NSDictionary *)queryParams:(NSDictionary *)params
{
    NSMutableDictionary *queryDictionary = @{}.mutableCopy;
    
    if (params[CBPAuthorId]) {
        queryDictionary[CBPAction] = CBPAuthorPosts;
        queryDictionary[CBPAuthorId] = params[CBPAuthorId];
    } else if (params[CBPCategoryId]) {
        queryDictionary[CBPAction] = CBPCategoryPosts;
        queryDictionary[CBPCategoryId] = params[CBPCategoryId];
    } else if (params[CBPPageSlug]) {
        queryDictionary[CBPAction] = CBPPage;
        queryDictionary[CBPPageSlug] = params[CBPPageSlug];
    } else if (params[CBPSearchQuery]) {
        queryDictionary[CBPAction] = CBPSearchResults;
        queryDictionary[CBPSearchQuery] = params[CBPSearchQuery];
    } else if (params[CBPTagId]) {
        queryDictionary[CBPAction] = CBPTagPosts;
        queryDictionary[CBPTagId] = params[CBPTagId];
    } else {
        queryDictionary[CBPAction] = @"1";
    }
    
    if (params[CBPCurrentPage] && ([params[CBPCurrentPage] intValue] > 1)) {
        queryDictionary[CBPCurrentPage] = params[CBPCurrentPage];
    }
    
    if (params[CBPCount] && ([params[CBPCount] intValue] > 1)) {
        queryDictionary[CBPCount] = params[CBPCount];
    }
              
    return queryDictionary;
}
@end
