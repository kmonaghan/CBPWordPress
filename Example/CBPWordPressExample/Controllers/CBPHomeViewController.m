//
//  CBPHomeViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 21/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPHomeViewController.h"

#import "CBPAboutViewController.h"
#import "CBPSubmitTipViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
    
    button.frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, button.frame.size.width + 13, button.frame.size.height);
    
    [button addTarget:self action:@selector(aboutAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                           target:self
                                                                                           action:@selector(tipAction)];
}

#pragma mark -
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

#pragma mark -
- (void)aboutAction
{
    CBPAboutViewController *vc = [[CBPAboutViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navController
                                            animated:YES
                                          completion:nil];
}

- (void)tipAction
{
    CBPSubmitTipViewController *vc = [[CBPSubmitTipViewController alloc] initWithStyle:UITableViewStyleGrouped];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self.navigationController presentViewController:navController
                                            animated:YES
                                          completion:nil];
}

@end
