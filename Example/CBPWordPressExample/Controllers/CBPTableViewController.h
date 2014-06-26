//
//  CBPTableViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 18/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBPTableViewController : UIViewController <UITableViewDelegate>
@property (nonatomic) UITableView *tableView;

- (void)startLoading;
- (void)stopLoading;
@end
