//
//  CBPPostListViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 29/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBPTableViewController.h"

#import "CBPWordPressDataSource.h"

@interface CBPPostListViewController : CBPTableViewController
@property (nonatomic) CBPWordPressDataSource *dataSource;

- (instancetype)initWithAuthorId:(NSNumber *)authorId;
- (instancetype)initWithCategoryId:(NSNumber *)categoryId;
- (instancetype)initWithTagId:(NSNumber *)tagId;

- (NSDictionary *)generateParams;
@end
