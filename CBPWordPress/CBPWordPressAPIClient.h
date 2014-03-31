//
//  CBPWordPressAPIClient.h
//  Pods
//
//  Created by Karl Monaghan on 31/03/2014.
//
//

#import "AFHTTPSessionManager.h"

@interface CBPWordPressAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
@end
