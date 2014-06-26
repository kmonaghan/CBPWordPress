//
//  CBPWordPressAttachment.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressAttachment.h"

#import "CBPWordPressImage.h"

@implementation CBPWordPressAttachment

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary
{
    CBPWordPressAttachment *instance = [[CBPWordPressAttachment alloc] init];
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
    if ([key isEqualToString:@"images"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSMutableArray *images = @[].mutableCopy;
            
            for (NSString *key in value) {
                [images addObject:[CBPWordPressImage initFromDictionary:value[key]]];
            }
            
            self.images = images;
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"attachmentId"];
    } else if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"descriptionText"];
    } else if ([key isEqualToString:@"mime_type"]) {
        [self setValue:value forKey:@"mimeType"];
    } else {
        //[super setValue:value forUndefinedKey:key];
        NSLog(@"Undefined key in attachment: %@ with value: %@", key, value);
    }
}

- (NSDictionary *)dictionaryRepresentation
{

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:@(self.attachmentId) forKey:@"attachmentId"];

    if (self.caption) {
        [dictionary setObject:self.caption forKey:@"caption"];
    }

    if (self.descriptionText) {
        [dictionary setObject:self.descriptionText forKey:@"descriptionText"];
    }

    if (self.images) {
        [dictionary setObject:self.images forKey:@"images"];
    }

    if (self.mimeType) {
        [dictionary setObject:self.mimeType forKey:@"mimeType"];
    }

    [dictionary setObject:@(self.parent) forKey:@"parent"];

    if (self.slug) {
        [dictionary setObject:self.slug forKey:@"slug"];
    }

    if (self.title) {
        [dictionary setObject:self.title forKey:@"title"];
    }

    if (self.url) {
        [dictionary setObject:self.url forKey:@"url"];
    }

    return dictionary;

}

@end
