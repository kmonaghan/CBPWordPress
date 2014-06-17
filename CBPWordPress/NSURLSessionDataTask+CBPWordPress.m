//
//  NSURLSessionDataTask+CBPWordPress.m
//  Pods
//
//  Created by Karl Monaghan on 31/03/2014.
//
//

#import "NSURLSessionDataTask+CBPWordPress.h"

#import "CBPWordPressAPIClient.h"

#import "CBPWordPressComment.h"
#import "CBPWordPressPost.h"
#import "CBPWordPressPostContainer.h"
#import "CBPWordPressPostsContainer.h"

@implementation NSURLSessionDataTask (CBPWordPress)
+ (NSURLSessionDataTask *)fetchPostWithURL:(NSURL *)url withBlock:(void (^)(CBPWordPressPost *post, NSError *error))block
{
    return [[CBPWordPressAPIClient sharedClient] GET:[url path] parameters:@{@"json": @1} success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
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

+ (NSURLSessionDataTask *)fetchPostsWithAuthorId:(NSInteger)authorId withBlock:(void (^)(CBPWordPressPostsContainer *data, NSError *error))block
{
    return [NSURLSessionDataTask fetchPostsWithParams:@{@"author_id": @(authorId)} withBlock:block];
}

+ (NSURLSessionDataTask *)fetchPostsWithParams:(NSDictionary *)params withBlock:(void (^)(CBPWordPressPostsContainer *data, NSError *error))block
{
    return [[CBPWordPressAPIClient sharedClient] GET:@"/?json=1" parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
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
    return [[CBPWordPressAPIClient sharedClient] GET:@"" parameters:@{@"json": @"get_post", @"post_id": @(postId)} success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        if ([JSON[@"status"] isEqualToString:@"ok"]) {
            CBPWordPressPost *post = [CBPWordPressPost initFromDictionary:JSON[@"post"]];
            
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
    return [[CBPWordPressAPIClient sharedClient] GET:@"/?json=respond.submit_comment" parameters:[comment dictionaryRepresentation] success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
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
