//
//  CBPWordPressImage.m
//  
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressImage.h"

@implementation CBPWordPressImage

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary
{
    CBPWordPressImage *instance = [[CBPWordPressImage alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary
{
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"Undefined key: %@ with value: %@", key, value);
}

@end
