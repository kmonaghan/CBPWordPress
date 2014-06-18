//
//  CBPPostListViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 29/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBPTableViewController.h"

@interface CBPPostListViewController : CBPTableViewController
- (instancetype)initWithCategoryId:(NSNumber *)categoryId;
- (instancetype)initWithTagId:(NSNumber *)tagId;
@end
