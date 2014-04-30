//
//  CBPWordPressPost.m
//
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

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
    } else if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"postId"];
    } else if ([key isEqualToString:@"title_plain"]) {
        [self setValue:value forKey:@"titlePlain"];
    } else {
        //[super setValue:value forUndefinedKey:key];
        NSLog(@"Undefined key post: %@ with value: %@", key, value);
    }
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
    
    [dictionary setObject:[NSNumber numberWithInteger:self.commentCount] forKey:@"commentCount"];
    
    if (self.commentStatus) {
        [dictionary setObject:self.commentStatus forKey:@"commentStatus"];
    }
    
    if (self.comments) {
        [dictionary setObject:self.comments forKey:@"comments"];
    }
    
    if (self.content) {
        [dictionary setObject:self.content forKey:@"content"];
    }
    
    if (self.date) {
        [dictionary setObject:self.date forKey:@"date"];
    }
    
    if (self.excerpt) {
        [dictionary setObject:self.excerpt forKey:@"excerpt"];
    }
    
    [dictionary setObject:[NSNumber numberWithInteger:self.postId] forKey:@"postId"];
    
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

- (NSString *)generateHtml:(CGFloat)fontSize
{
    if (!self.postHtml)
    {
        NSMutableString *html = @"".mutableCopy;
        
        [html appendFormat:@"<html><head><script type=\"text/javascript\" src=\"kmwordpress.js\"></script>"];
        
        [html appendFormat:@"<style>#singlentry {font-size: %fpx;}</style><link href='default.css' rel='stylesheet' type='text/css' />", fontSize];
        
        [html appendFormat:@"</head><body id=\"contentbody\"><div id='maincontent' class='content'><div class='post'><div id='title'>%@</div><div><span class='date-color'>%@</span>&nbsp;<a class='author' href=\"kmwordpress://author:%ld\">%@</a></div>",
         self.title,
         [self.date description],
         (long)self.author.authorId,
         self.author.name];
        
        [html appendFormat:@"<div id='singlentry'>%@</div></div>", self.content];
        
        if ([self.categories count])
        {
            [html appendString:@"<div>"];
            
            for (CBPWordPressCategory *item in self.categories)
            {
                [html appendFormat:@"<a class=\"category\" href=\"kmwordpress://category:%ld\">%@</a> ", (long)item.categoryId, item.title];
            }
            
            [html appendString:@"</div>"];
        }
        
        if ([self.tags count])
        {
            [html appendString:@"<div style=\"clear:both\">"];
            
            for (CBPWordPressTag *item in self.tags)
            {
                [html appendFormat:@"<a class=\"tag\" href=\"kmwordpress://tag:%ld\">%@</a>", (long)item.tagId, item.title];
            }
            
            [html appendString:@"</div>"];
        }
        
        if (([html rangeOfString:@"twitter-tweet"].location != NSNotFound) && ([html rangeOfString:@"widgets.js"].location == NSNotFound))
        {
            [html appendString:@"<script async src=\"//platform.twitter.com/widgets.js\" charset=\"utf-8\"></script>"];
        }
        
        html = [html stringByReplacingOccurrencesOfString:@"\"//platform.twitter.com/"
                                               withString:@"\"http://platform.twitter.com/"].mutableCopy;
        
        [html appendString:@"</div></body></html>"];
        
        self.postHtml = html;
    }
    return self.postHtml;
}

@end
