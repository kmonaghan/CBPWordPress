//
//  CBPCommentsViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBPTableViewController.h"

@class CBPWordPressPost;

@interface CBPCommentsViewController : CBPTableViewController
- (instancetype)initWithPost:(CBPWordPressPost *)post;
@end
