//
//  CBPWordPressPostContainer.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 06/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPWordPressPost;

@interface CBPWordPressPostContainer : NSObject
@property (nonatomic) NSString *error;
@property (nonatomic) CBPWordPressPost *post;
@property (nonatomic) NSString *status;

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;
@end
