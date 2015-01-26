//
//  CBPWordPressPost.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPWordPressAuthor;
@class CBPWordPressComment;

@interface CBPWordPressPost : NSObject

@property (nonatomic) NSArray *attachments;
@property (nonatomic) CBPWordPressAuthor *author;
@property (nonatomic) NSArray *categories;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic) NSString *commentStatus;
@property (nonatomic) NSArray *comments;
@property (nonatomic) NSString *content;
@property (nonatomic) NSDictionary *customFields;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *dateString;
@property (nonatomic) NSString *excerpt;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic) NSString *postHtml;
@property (nonatomic) NSDate *modified;
@property (nonatomic) NSString *nextTitle;
@property (nonatomic) NSString *nextURL;
@property (nonatomic) NSString *previousTitle;
@property (nonatomic) NSString *previousURL;
@property (nonatomic) NSString *slug;
@property (nonatomic) NSString *status;
@property (nonatomic) NSArray *tags;
@property (nonatomic) NSString *thumbnail;
@property (nonatomic) NSDictionary *thumbnailImages;
@property (nonatomic) NSString *thumbnailSize;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *titlePlain;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString *url;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;

- (void)addComment:(CBPWordPressComment *)comment;
- (void)insertComment:(CBPWordPressComment *)comment atIndex:(NSInteger) index;
- (NSDictionary *)dictionaryRepresentation;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
