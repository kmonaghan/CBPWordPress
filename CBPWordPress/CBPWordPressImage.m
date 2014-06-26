//
//  CBPWordPressImage.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 28/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressImage.h"

@implementation CBPWordPressImage
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.height) forKey:@"height"];
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:@(self.width) forKey:@"width"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.height = [(NSNumber *)[decoder decodeObjectForKey:@"height"] integerValue];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.width = [(NSNumber *)[decoder decodeObjectForKey:@"width"] integerValue];
    }
    return self;
}

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

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:@(self.height) forKey:@"height"];

    if (self.url) {
        [dictionary setObject:self.url forKey:@"url"];
    }

    [dictionary setObject:@(self.width) forKey:@"width"];

    return dictionary;

}


@end
