//
//  CBPCommentsViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPCommentsViewController.h"
#import "CBPComposeCommentViewController.h"

#import "CBPCommentDataSource.h"

#import "CBPWordPressPost.h"

@interface CBPCommentsViewController ()
@property (strong, nonatomic) CBPCommentDataSource *dataSource;
@property (strong, nonatomic) CBPWordPressPost *post;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation CBPCommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPost:(CBPWordPressPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self) {
        _post = post;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[CBPCommentDataSource alloc] initWithPost:self.post];
    
    self.tableView.dataSource = self.dataSource;
    
    if ([self.post.commentStatus isEqualToString:@"open"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                     target:self
                                                                                     action:@selector(composeCommentAction)];
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (void)composeCommentAction
{
    CBPComposeCommentViewController *vc = [CBPComposeCommentViewController new];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    
    return _tableView;
}

@end
