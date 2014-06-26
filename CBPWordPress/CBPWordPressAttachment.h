//
//  CBPWordPressAttachment.h
//  CBPWordPress
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

@interface CBPWordPressAttachment : NSObject

@property (nonatomic, assign) NSInteger attachmentId;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, assign) NSInteger parent;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;


+ (instancetype)initFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

- (NSDictionary *)dictionaryRepresentation;

@end
