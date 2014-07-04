//
//  CBPTableViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 18/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>
#import "TSMessage.h"

#import "CBPTableViewController.h"

@interface CBPTableViewController ()
@property (nonatomic) UILabel *errorLabel;
@property (nonatomic) UIView *errorView;
@property (nonatomic) UIView *loadingView;
@property (nonatomic) UIButton *reloadButton;
@end

@implementation CBPTableViewController

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.errorView];
    
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
    
    if (self.canInfiniteLoad) {
        __weak typeof(self) weakSelf = self;
        
        // setup infinite scrolling
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf load:YES];
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.canPullToRefresh) {
        __weak typeof(self) weakSelf = self;
        
        // setup pull-to-refresh
        [self.tableView addPullToRefreshWithActionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf load:NO];
        }];
    }
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
- (void)errorLoading:(NSError *)error
{
    self.errorLabel.text = error.localizedDescription;
    [self.errorLabel sizeToFit];
    self.errorLabel.center = self.errorView.center;
    
    [self.view bringSubviewToFront:self.errorView];
    
    [self stopLoading:NO];
}

- (void)load:(BOOL)more
{
    if (!more) {
        [self startLoading];
    }
}

- (void)reload
{
    [self load:NO];
}

- (void)showMessage:(NSString *)message
{
    [TSMessage showNotificationInViewController:self
                                          title:message
                                       subtitle:nil
                                           type:TSMessageNotificationTypeSuccess
                                       duration:5.0f
                           canBeDismissedByUser:YES];
}

- (void)startLoading
{
    [self.view bringSubviewToFront:self.loadingView];
    [self.view sendSubviewToBack:self.errorView];
    
    self.errorLabel.text = nil;
}

- (void)stopLoading:(BOOL)more
{
    [self.view sendSubviewToBack:self.loadingView];
    
    if (more) {
        [self.tableView.infiniteScrollingView stopAnimating];
    } else {
        [self.tableView.pullToRefreshView stopAnimating];
    }
}

#pragma mark -
- (UILabel *)errorLabel
{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - (CBPPadding * 2), 0)];
        _errorLabel.numberOfLines = 0;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - (CBPPadding * 2);
        _errorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }
    
    return _errorLabel;
}

- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [[UIView alloc] initWithFrame:self.tableView.frame];
        _errorView.backgroundColor = [UIColor whiteColor];
        
        [_errorView addSubview:self.errorLabel];
        [_errorView addSubview:self.reloadButton];
    }
    
    return _errorView;
}

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [[UIView alloc] initWithFrame:self.tableView.frame];
        _loadingView.backgroundColor = [UIColor whiteColor];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = _loadingView.center;
        [spinner startAnimating];
        
        [_loadingView addSubview:spinner];
    }
    
    return _loadingView;
}

- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setTitle:NSLocalizedString(@"Reload", nil) forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_reloadButton sizeToFit];
        
        _reloadButton.frame = CGRectMake((CGRectGetWidth(self.view.frame) - CGRectGetWidth(_reloadButton.frame)) / 2,
                                         CGRectGetHeight(self.view.frame) - CGRectGetHeight(_reloadButton.frame) - 150.0f,
                                         CGRectGetWidth(_reloadButton.frame),
                                         CGRectGetHeight(_reloadButton.frame));
    }
    
    return _reloadButton;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

@end
