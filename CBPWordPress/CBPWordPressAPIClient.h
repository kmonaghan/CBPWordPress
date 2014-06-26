//
//  CBPWordPressAPIClient.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CBPWordPressAPIClient : AFHTTPSessionManager
+ (instancetype)sharedClient;
+ (void)rootURI:(NSString *)URI;

- (NSDictionary *)queryParams:(NSDictionary *)params;
@end
