//
//  CBPWordPressPostContainer.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 06/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressPostContainer.h"

#import "CBPWordPressPost.h"

@implementation CBPWordPressPostContainer
+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary
{
    CBPWordPressPostContainer *instance = [[CBPWordPressPostContainer alloc] init];
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

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"post"]) {
        self.post = [CBPWordPressPost initFromDictionary:value];
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //[super setValue:value forUndefinedKey:key];
    NSLog(@"Undefined key in container: %@ with value: %@", key, value);
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *representation = @{}.mutableCopy;
    
    return representation;
}
@end
