//
//  CBPTableViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 18/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPTableViewController.h"

@interface CBPTableViewController ()
@property (nonatomic) UIView *loadingView;
@end

@implementation CBPTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    [self.view addSubview:self.loadingView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

#pragma mark -
- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.tableView reloadData];
}

#pragma mark -
- (void)startLoading
{
    [self.view bringSubviewToFront:self.loadingView];
}

- (void)stopLoading
{
    [self.view sendSubviewToBack:self.loadingView];
}

#pragma mark -
- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.view.frame];
        _loadingView.backgroundColor = [UIColor whiteColor];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = _loadingView.center;
        [spinner startAnimating];
        
        [_loadingView addSubview:spinner];
    }
    
    return _loadingView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end
