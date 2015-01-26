//
//  CBPWordPressPost.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSDateFormatter+CBPWordPress.h"

#import "CBPWordPressPost.h"

#import "CBPWordPressAttachment.h"
#import "CBPWordPressAuthor.h"
#import "CBPWordPressCategory.h"
#import "CBPWordPressComment.h"
#import "CBPWordPressTag.h"

@implementation CBPWordPressPost

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary
{
    CBPWordPressPost *instance = [[CBPWordPressPost alloc] init];
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
    if ([key isEqualToString:@"attachments"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                CBPWordPressAttachment *populatedMember = [CBPWordPressAttachment initFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            
            self.attachments = myMembers;
        }
    } else if ([key isEqualToString:@"author"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.author = [CBPWordPressAuthor initFromDictionary:value];
        }
    } else if ([key isEqualToString:@"categories"]) {
        if ([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                CBPWordPressCategory *populatedMember = [CBPWordPressCategory initFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            
            self.categories = myMembers;
            
        }
    } else if ([key isEqualToString:@"comments"]) {
        
        if ([value isKindOfClass:[NSArray class]])
        {
            
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                CBPWordPressComment *populatedMember = [CBPWordPressComment initFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            
            self.comments = myMembers;
            
        }
    } else if ([key isEqualToString:@"date"]) {
        self.dateString = value;
        self.date = [[NSDateFormatter cbp_sharedInstance] dateFromString:value];
    } else if ([key isEqualToString:@"tags"]) {
        if ([value isKindOfClass:[NSArray class]])
        {
            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                CBPWordPressTag *populatedMember = [CBPWordPressTag initFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }
            
            self.tags = myMembers;
        }
    } else {
        [super setValue:value forKey:key];
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"comment_count"]) {
        [self setValue:value forKey:@"commentCount"];
    } else if ([key isEqualToString:@"comment_status"]) {
        [self setValue:value forKey:@"commentStatus"];
    } else if ([key isEqualToString:@"custom_fields"]) {
        [self setValue:value forKey:@"customFields"];
    } else if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"postId"];
    } else if ([key isEqualToString:@"thumbnail_images"]) {
        [self setValue:value forKey:@"thumbnailImages"];
    } else if ([key isEqualToString:@"thumbnail_size"]) {
        [self setValue:value forKey:@"thumbnailSize"];
    } else if ([key isEqualToString:@"title_plain"]) {
        [self setValue:value forKey:@"titlePlain"];
    } else if ([key isEqualToString:@"next_title"]) {
        [self setValue:value forKey:@"nextTitle"];
    } else if ([key isEqualToString:@"next_url"]) {
        [self setValue:value forKey:@"nextURL"];
    } else if ([key isEqualToString:@"previous_title"]) {
        [self setValue:value forKey:@"previousTitle"];
    } else if ([key isEqualToString:@"previous_url"]) {
        [self setValue:value forKey:@"previousURL"];
    } else {
        //[super setValue:value forUndefinedKey:key];
        NSLog(@"Undefined key post: %@ with value: %@", key, value);
    }
}

- (void)addComment:(CBPWordPressComment *)comment
{
    NSMutableArray *newComments = self.comments.mutableCopy;
    [newComments addObject:comment];
    self.commentCount = [newComments count];
    
    self.comments = newComments;
}

- (void)insertComment:(CBPWordPressComment *)comment atIndex:(NSInteger) index
{
    NSMutableArray *newComments = self.comments.mutableCopy;
    [newComments insertObject:comment atIndex:index];
    self.commentCount = [newComments count];
    
    self.comments = newComments;
}

- (NSDictionary *)dictionaryRepresentation
{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.attachments) {
        [dictionary setObject:self.attachments forKey:@"attachments"];
    }
    
    if (self.author) {
        [dictionary setObject:self.author forKey:@"author"];
    }
    
    if (self.categories) {
        [dictionary setObject:self.categories forKey:@"categories"];
    }
    
    [dictionary setObject:@(self.commentCount) forKey:@"commentCount"];
    
    if (self.commentStatus) {
        [dictionary setObject:self.commentStatus forKey:@"commentStatus"];
    }
    
    if (self.comments) {
        [dictionary setObject:self.comments forKey:@"comments"];
    }
    
    if (self.content) {
        [dictionary setObject:self.content forKey:@"content"];
    }
    
    if (self.customFields) {
        [dictionary setObject:self.content forKey:@"custom_fields"];
    }
    
    if (self.date) {
        [dictionary setObject:self.date forKey:@"date"];
    }
    
    if (self.excerpt) {
        [dictionary setObject:self.excerpt forKey:@"excerpt"];
    }
    
    [dictionary setObject:@(self.postId) forKey:@"postId"];
    
    if (self.modified) {
        [dictionary setObject:self.modified forKey:@"modified"];
    }
    
    if (self.slug) {
        [dictionary setObject:self.slug forKey:@"slug"];
    }
    
    if (self.status) {
        [dictionary setObject:self.status forKey:@"status"];
    }
    
    if (self.tags) {
        [dictionary setObject:self.tags forKey:@"tags"];
    }
    
    if (self.thumbnail) {
        [dictionary setObject:self.thumbnail forKey:@"thumbnail"];
    }
    
    if (self.thumbnailImages) {
        [dictionary setObject:self.thumbnail forKey:@"thumbnail_images"];
    }
    
    if (self.thumbnailSize) {
        [dictionary setObject:self.thumbnail forKey:@"thumbnail_size"];
    }
    
    if (self.title) {
        [dictionary setObject:self.title forKey:@"title"];
    }
    
    if (self.titlePlain) {
        [dictionary setObject:self.titlePlain forKey:@"titlePlain"];
    }
    
    if (self.type) {
        [dictionary setObject:self.type forKey:@"type"];
    }
    
    if (self.url) {
        [dictionary setObject:self.url forKey:@"url"];
    }
    
    return dictionary;
}

#pragma mark -
- (NSString *)thumbnail
{
    if (!_thumbnail) {
        if ([self.attachments count]) {
            CBPWordPressAttachment *attachment = [self.attachments firstObject];
            
            _thumbnail = attachment.url;
        }
    }
    
    return _thumbnail;
}

@end
