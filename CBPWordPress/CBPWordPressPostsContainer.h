//
//  CBPWordPressPostsContainer.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPWordPressCategory;
@class CBPWordPressTag;

@interface CBPWordPressPostsContainer : NSObject

@property (nonatomic) CBPWordPressCategory *category;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger countTotal;
@property (nonatomic) NSString *error;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic) NSArray *posts;
@property (nonatomic) NSString *status;
@property (nonatomic) CBPWordPressTag *tag;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
