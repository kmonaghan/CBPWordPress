//
//  NSURLSessionDataTask+CBPWordPress.h
//  Pods
//
//  Created by Karl Monaghan on 31/03/2014.
//
//

#import <Foundation/Foundation.h>

@class CBPWordPressPost;
@class CBPWordPressPostContainer;

@interface NSURLSessionDataTask (CBPWordPress)
+ (NSURLSessionDataTask *)fetchPostsWithParams:(NSDictionary *)params
                                     withBlock:(void (^)(CBPWordPressPostContainer *data, NSError *error))block;
+ (NSURLSessionDataTask *)fetchPostWithId:(NSInteger)postId
                                withBlock:(void (^)(CBPWordPressPost *post, NSError *error))block;
@end
