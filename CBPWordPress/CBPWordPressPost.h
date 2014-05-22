//
//  CBPWordPressPost.h
//  
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPWordPressAuthor;

@interface CBPWordPressPost : NSObject

@property (nonatomic, strong) NSArray *attachments;
@property (nonatomic, strong) CBPWordPressAuthor *author;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, strong) NSString *commentStatus;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *excerpt;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, strong) NSString *postHtml;
@property (nonatomic, strong) NSDate *modified;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titlePlain;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *url;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;
@end
