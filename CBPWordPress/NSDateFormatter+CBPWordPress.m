//
//  NSDateFormatter+CBPWordPress.m
//  Pods
//
//  Created by Karl Monaghan on 15/05/2014.
//
//

#import "NSDateFormatter+CBPWordPress.h"

@implementation NSDateFormatter (CBPWordPress)
+ (instancetype)cbp_sharedInstance
{
    static NSDateFormatter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NSDateFormatter alloc] init];
        [_sharedInstance setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    
    return _sharedInstance;
}
@end
