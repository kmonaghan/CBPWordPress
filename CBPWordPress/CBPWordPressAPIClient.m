//
//  CBPWordPressAPIClient.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressAPIClient.h"

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
    
    if (params[@"author_id"]) {
        queryDictionary[@"json"] = @"get_author_posts";
        queryDictionary[@"author_id"] = params[@"author_id"];
    } else if (params[@"category_id"]) {
        queryDictionary[@"json"] = @"get_category_posts";
        queryDictionary[@"category_id"] = params[@"category_id"];
    } else if (params[@"tag_id"]) {
        queryDictionary[@"json"] = @"get_tag_posts";
        queryDictionary[@"tag_id"] = params[@"tag_id"];
    } else {
        queryDictionary[@"json"] = @"1";
    }

    if (params[@"s"]) {
        queryDictionary[@"s"] = params[@"s"];
    }
    
    if (params[@"page"]) {
        queryDictionary[@"page"] = params[@"page"];
    }
    
    if (params[@"count"]) {
        queryDictionary[@"count"] = params[@"count"];
    }
              
    return queryDictionary;
}
@end
