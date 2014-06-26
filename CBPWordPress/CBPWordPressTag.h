//
//  CBPWordPressTag.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPWordPressTag : NSObject

@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, assign) NSInteger postCount;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, strong) NSString *title;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
