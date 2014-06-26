//
//  CBPWordPressAuthor.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPWordPressAuthor : NSObject

@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, assign) NSInteger authorId;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *url;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
