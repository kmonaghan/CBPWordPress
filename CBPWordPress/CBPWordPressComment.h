//
//  CBPWordPressComment.h
//  
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPWordPressComment : NSObject

@property (nonatomic, strong) id avatar;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger parent;
@property (nonatomic, strong) NSString *url;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
