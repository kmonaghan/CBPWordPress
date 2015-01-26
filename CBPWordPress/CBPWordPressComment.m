//
//  CBPWordPressComment.m
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSDateFormatter+CBPWordPress.h"

#import "CBPWordPressComment.h"
#import "CBPWordPressAuthor.h"

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

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"author"]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            self.author = [CBPWordPressAuthor initFromDictionary:value];
        }
    } else if ([key isEqualToString:@"date"]) {
        self.date = [[NSDateFormatter cbp_sharedInstance] dateFromString:value];
    } else if ([key isEqualToString:@"level"]) {
        self.level = [value intValue];
    } else {
        [super setValue:value forKey:key];
    }
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
    
    if (self.email) {
        [dictionary setObject:self.email
                       forKey:@"email"];
    }

    [dictionary setObject:@(self.commentId) forKey:@"id"];

    if (self.name) {
        [dictionary setObject:self.name forKey:@"name"];
    }

    [dictionary setObject:@(self.parent) forKey:@"parent"];
    [dictionary setObject:@(self.parent) forKey:@"comment_parent"];

    [dictionary setObject:@(self.postId) forKey:@"post_id"];

    if (self.url) {
        [dictionary setObject:self.url forKey:@"url"];
    }

    return dictionary;

}

/**
 * The comments can be encoded in a few different ways so we'll try and fall back to different encodings. 
 * In my own installs I've found that the encoding as more like in this order:
 * NSWindowsCP1252StringEncoding
 * NSISOLatin1StringEncoding
 * NSUTF8StringEncoding
 */
- (NSAttributedString *)contentAttributedString
{
    if (!_contentAttributedString) {
        NSError *error;
        
        _contentAttributedString = [[NSAttributedString alloc] initWithData:[self.content dataUsingEncoding:NSWindowsCP1252StringEncoding]
                                         options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                              documentAttributes:nil
                                                                      error:&error];
        
        if (error) {
            _contentAttributedString = [[NSAttributedString alloc] initWithData:[self.content dataUsingEncoding:NSISOLatin1StringEncoding]
                                                                        options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                             documentAttributes:nil
                                                                          error:&error];
            
            if (error) {
                _contentAttributedString = [[NSAttributedString alloc] initWithData:[self.content dataUsingEncoding:NSUTF8StringEncoding]
                                                                            options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                 documentAttributes:nil
                                                                              error:&error];
                
                if (error) {
                    _contentAttributedString = nil;
                }
            }
        }
    }
    
    return _contentAttributedString;
}
@end
