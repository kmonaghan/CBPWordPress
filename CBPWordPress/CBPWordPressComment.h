//
//  CBPWordPressComment.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPWordPressAuthor;

@interface CBPWordPressComment : NSObject

@property (nonatomic) CBPWordPressAuthor *author;
@property (nonatomic) NSString *avatar;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic) NSString *content;
@property (nonatomic) NSAttributedString *contentAttributedString;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSString *email;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic) NSString *name;
@property (nonatomic, assign) NSInteger parent;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic) NSString *url;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
