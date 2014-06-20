//
//  CBPWordPressAPIClient.m
//  Pods
//
//  Created by Karl Monaghan on 31/03/2014.
//
//

#import "CBPWordPressAPIClient.h"

@implementation CBPWordPressAPIClient
+ (instancetype)sharedClient
{
    static CBPWordPressAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CBPWordPressAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://localhost"]];
        [_sharedClient.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    });
    
    return _sharedClient;
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
    
    if (params[@"page"]) {
        queryDictionary[@"page"] = params[@"page"];
    }
    
    if (params[@"count"]) {
        queryDictionary[@"count"] = params[@"count"];
    }
              
    return queryDictionary;
}
@end
