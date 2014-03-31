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
@end
