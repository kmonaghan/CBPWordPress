//
//  CBPWordPressImage.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 28/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPWordPressImage : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) NSInteger width;

+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
