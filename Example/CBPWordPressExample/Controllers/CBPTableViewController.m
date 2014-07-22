//
//  CBPTableViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 18/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>

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
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.errorView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0f
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0f
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.canPullToRefresh) {
        // setup pull-to-refresh
        [self.tableView addPullToRefreshWithActionHandler:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf load:NO];
        }];
    }
    
    if (self.canInfiniteLoad) {
        // setup infinite scrolling
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf load:YES];
        }];
    }
    
    [self stopLoading:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.errorLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.view.frame) - (CBPPadding * 2);
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
        _errorLabel = [UILabel new];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
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
        _errorView = [UIView new];
        _errorView.translatesAutoresizingMaskIntoConstraints = NO;
        _errorView.backgroundColor = [UIColor whiteColor];
        
        [_errorView addSubview:self.errorLabel];
        [_errorView addSubview:self.reloadButton];
        
        NSDictionary *views = @{@"errorLabel": self.errorLabel,
                                @"reloadButton": self.reloadButton};
        [_errorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[errorLabel]-(40)-[reloadButton]"
                                                                           options:NSLayoutFormatAlignAllCenterX
                                                                           metrics:nil
                                                                             views:views]];
        [_errorView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[errorLabel]-(padding)-|"
                                                                           options:0
                                                                           metrics:@{@"padding": @(CBPPadding)}
                                                                             views:views]];
        [_errorView addConstraint:[NSLayoutConstraint constraintWithItem:self.errorLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_errorView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0f
                                                                constant:0]];
    }
    
    return _errorView;
}

- (UIView *)loadingView
{
    if (!_loadingView) {
        _loadingView = [UIView new];
        _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
        _loadingView.backgroundColor = [UIColor whiteColor];
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.translatesAutoresizingMaskIntoConstraints = NO;
        [spinner startAnimating];
        
        [_loadingView addSubview:spinner];
        
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:spinner
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_loadingView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0]];
        [_loadingView addConstraint:[NSLayoutConstraint constraintWithItem:spinner
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_loadingView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0]];
    }
    
    return _loadingView;
}

- (UIButton *)reloadButton
{
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_reloadButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
        [_reloadButton setTitle:NSLocalizedString(@"Reload", nil) forState:UIControlStateNormal];
        [_reloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_reloadButton sizeToFit];
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
