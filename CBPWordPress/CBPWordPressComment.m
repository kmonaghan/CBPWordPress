//
//  CBPWordPressComment.m
//  
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressComment.h"

@implementation CBPWordPressComment

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary
{

    CBPWordPressComment *instance = [[CBPWordPressComment alloc] init];
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
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"commentId"];
    } else {
        //[super setValue:value forUndefinedKey:key];
        NSLog(@"Undefined key in comment: %@ with value: %@", key, value);
    }
}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.avatar) {
        [dictionary setObject:self.avatar forKey:@"avatar"];
    }

    if (self.content) {
        [dictionary setObject:self.content forKey:@"content"];
    }

    if (self.date) {
        [dictionary setObject:self.date forKey:@"date"];
    }

    [dictionary setObject:[NSNumber numberWithInteger:self.commentId] forKey:@"commentId"];

    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }

    [dictionary setObject:[NSNumber numberWithInteger:self.parent] forKey:@"parent"];

    if (self.url) {
        [dictionary setObject:self.url forKey:@"url"];
    }

    return dictionary;

}

@end
