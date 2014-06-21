//
//  CBPHomeViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 21/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPHomeViewController.h"

@interface CBPHomeViewController ()

@end

@implementation CBPHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)backgroundUpdateWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self.dataSource updateWithBlock:^(BOOL result, NSError *error) {
        if (error) {
            completionHandler(UIBackgroundFetchResultFailed);
            return;
        }
        
        if (result) {
            completionHandler(UIBackgroundFetchResultNewData);
            
            [self.tableView reloadData];
        } else {
            completionHandler(UIBackgroundFetchResultNoData);
        };
    }];
}

@end
