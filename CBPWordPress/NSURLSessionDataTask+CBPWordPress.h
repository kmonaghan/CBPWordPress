//
//  NSURLSessionDataTask+CBPWordPress.h
//  Pods
//
//  Created by Karl Monaghan on 31/03/2014.
//
//

#import <Foundation/Foundation.h>

@class CBPWordPressPostContainer;

@interface NSURLSessionDataTask (CBPWordPress)
+ (NSURLSessionDataTask *)fetchPostsWithParams:(NSDictionary *)params
                                     withBlock:(void (^)(CBPWordPressPostContainer *data, NSError *error))block;

@end
