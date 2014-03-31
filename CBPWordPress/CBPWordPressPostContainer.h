//
//  CBPWordPressPostContainer.h
//  
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPWordPressPostContainer : NSObject

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger countTotal;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSString *status;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
