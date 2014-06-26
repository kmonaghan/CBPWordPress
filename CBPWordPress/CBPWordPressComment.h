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
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger parent;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, strong) NSString *url;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
