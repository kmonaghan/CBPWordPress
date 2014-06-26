//
//  CBPHomeViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 21/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "CBPHomeViewController.h"

#import "CBPAboutViewController.h"
#import "CBPSubmitTipViewController.h"

@interface CBPHomeViewController ()
@property (nonatomic) UIImageView *titleImageView;
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
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"broadsheet_black"]];
    
    self.navigationItem.titleView = self.titleImageView;
    
    [self updateHeaderImage];
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

#pragma mark -
- (void)updateHeaderImage
{
    __weak typeof(self) weakSelf = self;
    
    [self.titleImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://broadsheet.ie/logo/iphone_logo.png"]]
                               placeholderImage:[UIImage imageNamed: @"broadsheet_black"]
                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"header.png"];

                                            dispatch_async(dispatch_queue_create("com.crayonsandbrownpaper.myqueue", 0), ^{
                                                [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                                            });
                                            
                                            __strong typeof(self) strongSelf = weakSelf;
                                            strongSelf.titleImageView.image = image;
                                            strongSelf.navigationItem.titleView = strongSelf.titleImageView;
                                        }
                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                            NSLog(@"Error: %@", error);
                                        }];
}
@end
