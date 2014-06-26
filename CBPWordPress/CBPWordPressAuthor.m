//
//  CBPWordPressAuthor.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressAuthor.h"

@implementation CBPWordPressAuthor

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary
{

    CBPWordPressAuthor *instance = [[CBPWordPressAuthor alloc] init];
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
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionText"];
    } else if ([key isEqualToString:@"first_name"]) {
        [self setValue:value forKey:@"firstName"];
    } else if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"authorId"];
    } else if ([key isEqualToString:@"last_name"]) {
        [self setValue:value forKey:@"lastName"];
    } else {
        //[super setValue:value forUndefinedKey:key];
        NSLog(@"Undefined key in author: %@ with value: %@", key, value);
    }
}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    if (self.descriptionText) {
        [dictionary setObject:self.descriptionText forKey:@"descriptionText"];
    }

    if (self.firstName) {
        [dictionary setObject:self.firstName forKey:@"firstName"];
    }

    [dictionary setObject:@(self.authorId) forKey:@"authorId"];

    if (self.lastName) {
        [dictionary setObject:self.lastName forKey:@"lastName"];
    }

    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }

    if (self.nickname) {
        [dictionary setObject:self.nickname forKey:@"nickname"];
    }

    if (self.slug) {
        [dictionary setObject:self.slug forKey:@"slug"];
    }

    if (self.url) {
        [dictionary setObject:self.url forKey:@"url"];
    }

    return dictionary;

}

@end
