//
//  NSURLSessionDataTask+CBPWordPress.h
//  Pods
//
//  Created by Karl Monaghan on 31/03/2014.
//
//

#import <Foundation/Foundation.h>

@class CBPWordPressComment;
@class CBPWordPressPost;
@class CBPWordPressPostsContainer;

@interface NSURLSessionDataTask (CBPWordPress)
+ (NSURLSessionDataTask *)fetchPostWithURL:(NSURL *)url
                                 withBlock:(void (^)(CBPWordPressPost *post, NSError *error))block;
+ (NSURLSessionDataTask *)fetchPostsWithParams:(NSDictionary *)params
                                     withBlock:(void (^)(CBPWordPressPostsContainer *data, NSError *error))block;
+ (NSURLSessionDataTask *)fetchPostWithId:(NSInteger)postId
                                withBlock:(void (^)(CBPWordPressPost *post, NSError *error))block;
+ (NSURLSessionDataTask *)postComment:(CBPWordPressComment *)comment
                            withBlock:(void (^)(CBPWordPressComment *comment, NSError *error))block;

@end
