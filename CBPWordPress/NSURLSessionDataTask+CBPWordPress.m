//
//  NSURLSessionDataTask+CBPWordPress.m
//  Pods
//
//  Created by Karl Monaghan on 31/03/2014.
//
//

#import "NSURLSessionDataTask+CBPWordPress.h"

#import "CBPWordPressAPIClient.h"

#import "CBPWordPressPostContainer.h"

@implementation NSURLSessionDataTask (CBPWordPress)
+ (NSURLSessionDataTask *)fetchPostsWithParams:(NSDictionary *)params withBlock:(void (^)(CBPWordPressPostContainer *data, NSError *error))block
{
    return [[CBPWordPressAPIClient sharedClient] GET:@"/?json=1" parameters:params success:^(NSURLSessionDataTask * __unused task, id JSON) {
        
        CBPWordPressPostContainer *container = [CBPWordPressPostContainer initFromDictionary:JSON];
        
        if (block) {
            block(container, nil);
        }
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}
@end
