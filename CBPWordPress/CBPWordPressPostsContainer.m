//
//  CBPWordPressPostsContainer.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPressPostsContainer.h"

#import "CBPWordPressCategory.h"
#import "CBPWordPressPost.h"
#import "CBPWordPressTag.h"

@implementation CBPWordPressPostsContainer

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary
{
    CBPWordPressPostsContainer *instance = [[CBPWordPressPostsContainer alloc] init];
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
    if ([key isEqualToString:@"category"]) {
        self.category = [CBPWordPressCategory initFromDictionary:value];
    } else if ([key isEqualToString:@"posts"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                CBPWordPressPost *populatedMember = [CBPWordPressPost initFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            
            self.posts = myMembers;
        }
    } else if ([key isEqualToString:@"tag"]) {
        self.tag = [CBPWordPressTag initFromDictionary:value];
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"count_total"]) {
        [self setValue:value forKey:@"countTotal"];
    } else {
        //[super setValue:value forUndefinedKey:key];
        NSLog(@"Undefined key in container: %@ with value: %@", key, value);
    }
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:@(self.count) forKey:@"count"];
    
    [dictionary setObject:@(self.countTotal) forKey:@"countTotal"];
    
    [dictionary setObject:@(self.pages) forKey:@"pages"];
    
    if (self.posts) {
        [dictionary setObject:self.posts forKey:@"posts"];
    }
    
    if (self.status) {
        [dictionary setObject:self.status forKey:@"status"];
    }
    
    return dictionary;
}

@end
