//
//  NSURLSessionDataTask+CBPWordPress.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSURLSessionDataTask+CBPWordPress.h"

#import "CBPWordPressAPIClient.h"

#import "CBPWordPressComment.h"
#import "CBPWordPressPost.h"
#import "CBPWordPressPostContainer.h"
#import "CBPWordPressPostsContainer.h"
#import "CBPWordPressSearchParamters.h"

@implementation NSURLSessionDataTask (CBPWordPress)
+ (NSURLSessionDataTask *)fetchPostWithURL:(NSURL *)url withBlock:(void (^)(CBPWordPressPost *post, NSError *error))block
{
    return [[CBPWordPressAPIClient sharedClient] GET:[url path] parameters:@{CBPAction: @1} success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        CBPWordPressPostContainer *container = [CBPWordPressPostContainer initFromDictionary:JSON];
        if ([JSON[@"status"] isEqualToString:@"ok"]) {
            if (block) {
                block(container.post, nil);
            }
        } else {
            block(nil, [NSError errorWithDomain:@"CBPWordPressError" code:0 userInfo:@{@"error": JSON[@"error"]}]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)fetchPostsWithParams:(NSDictionary *)params withBlock:(void (^)(CBPWordPressPostsContainer *data, NSError *error))block
{
    return [[CBPWordPressAPIClient sharedClient] GET:@"" parameters:[[CBPWordPressAPIClient sharedClient] queryParams:params] success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        CBPWordPressPostsContainer *container = [CBPWordPressPostsContainer initFromDictionary:JSON];
        
        if (block) {
            block(container, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)fetchPostWithId:(NSInteger)postId withBlock:(void (^)(CBPWordPressPost *post, NSError *error))block
{
    return [[CBPWordPressAPIClient sharedClient] GET:@"" parameters:@{CBPAction: CBPPost, CBPPostId: @(postId)} success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        if ([JSON[@"status"] isEqualToString:@"ok"]) {
            CBPWordPressPost *post = [CBPWordPressPost initFromDictionary:JSON];
            
            if (block) {
                block(post, nil);
            }
        } else {
            block(nil, [NSError errorWithDomain:@"CBPWordPressError" code:0 userInfo:@{@"error": JSON[@"error"]}]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

+ (NSURLSessionDataTask *)postComment:(CBPWordPressComment *)comment withBlock:(void (^)(CBPWordPressComment *comment, NSError *error))block
{
    NSLog(@"[comment dictionaryRepresentation]: %@", [comment dictionaryRepresentation]);
    
    return [[CBPWordPressAPIClient sharedClient] POST:@"/?json=respond.submit_comment" parameters:[comment dictionaryRepresentation] success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        NSLog(@"JSON: %@", JSON);
        
        if ([JSON[@"status"] isEqualToString:@"ok"]) {
            CBPWordPressComment *comment = [CBPWordPressComment initFromDictionary:JSON[@"comment"]];
            
            if (block) {
                block(comment, nil);
            }
        } else {
            block(nil, [NSError errorWithDomain:@"CBPWordPressError" code:0 userInfo:@{@"error": JSON[@"error"]}]);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
