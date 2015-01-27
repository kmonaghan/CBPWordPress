//
//  CBPPostViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 22/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "NSString+CBPWordPressExample.h"
#import "NSString+HTML.h"

#import "SSCWhatsAppActivity.h"
#import "MHGallery.h"
#import "TOWebViewController.h"

#import "CBPCommentsViewController.h"
#import "CBPComposeCommentViewController.h"
#import "CBPPostListViewController.h"
#import "CBPPostViewController.h"

#import "CBPWordPressDataSource.h"

static const CGFloat CBPLoadPostViewHeight = 75.0;
static const CGFloat CBPLoadPostViewPadding = 10.0;
static const CGFloat CBPLoadPostViewMultiplier = 1.5;

static NSString * const kContentOffsetString = @"contentOffset";
static NSString * const kFrameString = @"frame";

@interface CBPPostViewController () <UIAlertViewDelegate, UIScrollViewDelegate, UIWebViewDelegate>
@property (nonatomic, assign) BOOL alertShown;
@property (nonatomic, assign) CGFloat baseFontSize;
@property (nonatomic, weak) CBPWordPressDataSource *dataSource;
@property (nonatomic) NSInteger index;
@property (nonatomic) UIBarButtonItem *nextPostButton;
@property (nonatomic) UILabel * nextTitleLabel;
@property (nonatomic) UIView *nextView;
@property (nonatomic, assign) BOOL pinchAllowed;
@property (nonatomic) CBPWordPressPost *post;
@property (nonatomic) UIBarButtonItem *postCommentButton;
@property (nonatomic) UIBarButtonItem *previousPostButton;
@property (nonatomic) UILabel * previousTitleLabel;
@property (nonatomic) UIView *previousView;
@property (nonatomic, assign) BOOL scrollToMore;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSURL *url;
@property (nonatomic) UIBarButtonItem *viewCommentsButton;
@property (nonatomic) UIWebView *webView;
@end

@implementation CBPPostViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _baseFontSize = [[NSUserDefaults standardUserDefaults] floatForKey:CBPUserFontSize];
        
        if (!_baseFontSize) {
            _baseFontSize = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody].pointSize;
        } else {
            _pinchAllowed = YES;
        }
    }
    
    return self;
}

- (instancetype)initWithPost:(CBPWordPressPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self) {
        _post = post;
    }
    
    return self;
}

- (instancetype)initWithPost:(CBPWordPressPost *)post withDataSource:(CBPWordPressDataSource *)dataSource withIndex:(NSInteger)index
{
    self = [self initWithPost:post];
    
    if (self) {
        _dataSource = dataSource;
        _index = index;
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)url
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self) {
        _url = url;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.nextView];
    
    [self.view addSubview:self.previousView];
    
    [self.view addSubview:self.webView];
    
    NSDictionary *views = @{@"nextView": self.nextView,
                            @"previousView": self.previousView};
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nextView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:CBPLoadPostViewHeight]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[nextView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.previousView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0f
                                                           constant:CBPLoadPostViewHeight]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[previousView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    self.scrollView = self.webView.scrollView;
    self.scrollView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.post) {
        [self displayPost];
    } else if (self.url) {
        [self loadPost];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.post) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
    
    [self.scrollView addObserver:self
                      forKeyPath:kContentOffsetString
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior
                         context:NULL];
    [self.scrollView addObserver:self
                      forKeyPath:kFrameString
                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionPrior
                         context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self.scrollView removeObserver:self
                         forKeyPath:kContentOffsetString
                            context:NULL];
    [self.scrollView removeObserver:self
                         forKeyPath:kFrameString
                            context:NULL];
}

- (void)toolbarButtons
{
    NSMutableArray *buttons = @[].mutableCopy;
    
    self.viewCommentsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                            target:self
                                                                            action:@selector(viewCommentAction)];
    [buttons addObject:self.viewCommentsButton];
    self.viewCommentsButton.enabled = NO;
    
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    self.nextPostButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"up4-25"]
                                                           style:UIBarButtonItemStylePlain
                                                          target:self
                                                          action:@selector(loadNextAction)];
    self.nextPostButton.enabled = NO;
    [buttons addObject:self.nextPostButton];
    
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    self.previousPostButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down4-25"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(loadPreviousAction)];
    self.previousPostButton.enabled = NO;
    [buttons addObject:self.previousPostButton];
    
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    self.postCommentButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                           target:self
                                                                           action:@selector(composeCommentAction)];
    [buttons addObject:self.postCommentButton];
    self.postCommentButton.enabled = NO;
    [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(sharePostAction)];
    [buttons addObject:share];
    
    [self setToolbarItems:buttons animated:YES];
}

#pragma mark -
- (void)displayPost
{
    [self.webView loadHTMLString:[NSString cbp_HTMLStringFor:self.post withFontSize:self.baseFontSize]
                         baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    [self updateToolbar];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    self.previousView.hidden = ![self canLoadPrevious];
    self.nextView.hidden = ![self canLoadNext];
}

- (void)loadPost
{
    __weak typeof(self) weakSelf = self;
    
    [NSURLSessionDataTask fetchPostWithURL:self.url
                                 withBlock:^(CBPWordPressPost *post, NSError *error) {
                                     if (!error) {
                                         __strong typeof(weakSelf) strongSelf = weakSelf;
                                         
                                         strongSelf.post = post;
                                         
                                         if (strongSelf.dataSource && (strongSelf.index >= [strongSelf.dataSource.posts count])) {
                                             [strongSelf.dataSource addPost:post];
                                         }
                                         
                                         [strongSelf displayPost];
                                     } else {
                                         NSLog(@"Error: %@", error);
                                         
                                     }
                                 }];
}

- (void)loadNextAction
{
    if ([self canLoadNext]) {
        self.index--;
        
        self.post = [self.dataSource postAtIndex:self.index];
        
        [self displayPost];
    }
}

- (void)loadPreviousAction
{
    if ([self canLoadPrevious]) {
        self.index++;
        
        if (self.index < [self.dataSource.posts count]) {
            self.post = [self.dataSource postAtIndex:self.index];
            
            [self displayPost];
        } else if (self.post.previousURL) {
            // Update the content inset
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CBPLoadPostViewHeight, 0);
            
            self.url = [NSURL URLWithString:self.post.previousURL];
            
            [self loadPost];
        }
    }
}

- (void)updateToolbar
{
    if (![self.toolbarItems count]) {
        [self toolbarButtons];
    }
    
    BOOL previousEnabled = NO;
    BOOL nextEnabled = NO;
    if (self.dataSource) {
        if (self.index) {
            nextEnabled = YES;
        }
        
        if (self.index < [self.dataSource.posts count]) {
            previousEnabled = YES;
        } else if (self.index == ([self.dataSource.posts count] - 1)) {
            if (self.post.previousTitle) {
                previousEnabled = YES;
            }
        }
    } else {
        if (self.post.nextTitle) {
            nextEnabled = YES;
        }
        
        if (self.post.previousTitle) {
            previousEnabled = YES;
        }
    }
    
    self.previousPostButton.enabled = previousEnabled;
    self.nextPostButton.enabled = nextEnabled;
    
    self.postCommentButton.enabled = ([self.post.commentStatus isEqualToString:@"open"]);
    
    self.viewCommentsButton.enabled = (self.post.commentCount) ? YES : NO;
}

#pragma mark - Button Actions
- (void)composeCommentAction
{
    __weak typeof(self) weakSelf = self;
    
    commentCompletionBlock block = ^(CBPWordPressComment *comment, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (comment) {
            [strongSelf.post addComment:comment];
            strongSelf.viewCommentsButton.enabled = YES;
        }
        
        [strongSelf.navigationController dismissViewControllerAnimated:YES
                                                            completion:^() {
                                                                if (comment) {
                                                                    [strongSelf showMessage:NSLocalizedString(@"Comment submitted", nil)];
                                                                }
                                                            }];
    };
    
    CBPComposeCommentViewController *vc = [[CBPComposeCommentViewController alloc] initWithPostId:self.post.postId
                                                                              withCompletionBlock:block];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)sharePostAction
{
    NSArray* activityItems = @[self.post.title,
                               [NSURL URLWithString:self.post.url]];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[[SSCWhatsAppActivity new]]];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeAirDrop, UIActivityTypePostToTencentWeibo ];
    
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)showGallery:(NSString *)uri
{
    NSUInteger index = [self.post.attachments indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[(CBPWordPressAttachment *)obj url] isEqualToString:uri]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    NSMutableArray *galleryData = @[].mutableCopy;
    
    for (CBPWordPressAttachment *attachment in self.post.attachments) {
        MHGalleryItem *image = [[MHGalleryItem alloc] initWithURL:attachment.url
                                                      galleryType:MHGalleryTypeImage];
        
        [galleryData addObject:image];
    }
    
    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
    gallery.galleryItems = galleryData;
    
    MHUICustomization *viewCustomization = [MHUICustomization new];
    viewCustomization.showOverView = NO;
    
    gallery.UICustomization = viewCustomization;
    
    if (index != NSNotFound) {
        gallery.presentationIndex = index;
    }
    
    __weak MHGalleryController *blockGallery = gallery;
    
    gallery.finishedCallback = ^(NSInteger currentIndex, UIImage *image,MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockGallery dismissViewControllerAnimated:YES dismissImageView:nil completion:nil];
        });
        
    };
    [self presentMHGalleryController:gallery animated:YES completion:nil];
}

- (void)viewCommentAction
{
    CBPCommentsViewController *vc = [[CBPCommentsViewController alloc] initWithPost:self.post];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
- (BOOL)canLoadNext
{
    if ([self.dataSource.posts count] > 1) {
        if ((self.index > 0) && (self.index < [self.dataSource.posts count])) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)canLoadPrevious
{
    if (self.dataSource
        && (((self.index + 1) < [self.dataSource.posts count])
            || (self.post.previousURL))) {
            return YES;
        }
    
    return NO;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setFloat:self.baseFontSize forKey:CBPUserFontSize];
    
    [defaults synchronize];
    
    self.pinchAllowed = YES;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
        //show images in the in-app browser
        if ([[[request URL] host] hasPrefix:CBPImageURL]) {
            NSArray *parts = [[[request URL] absoluteString] componentsSeparatedByString:@"."];
            
            NSString *ext = [[parts lastObject] lowercaseString];
            
            if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]
                || [ext isEqualToString:@"png"]
                || [ext isEqualToString:@"gif"]) {
                [self showGallery:[[request URL] absoluteString]];
            }
            //Capture CBPWordPress links
        } else if ([[[request URL] scheme] hasSuffix:@"cbpwordpress"]) {
            CBPPostListViewController *vc;
            
            if ([[[request URL] host] hasSuffix:@"author"]) {
                vc = [[CBPPostListViewController alloc] initWithAuthorId:[[request URL] port]];
            } else if ([[[request URL] host] hasSuffix:@"category"]) {
                vc = [[CBPPostListViewController alloc] initWithCategoryId:[[request URL] port]];
            } else if ([[[request URL] host] hasSuffix:@"tag"]) {
                vc = [[CBPPostListViewController alloc] initWithTagId:[[request URL] port]];
            }
            
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
            //Read More link
        } else if ([[[request URL] absoluteString] hasSuffix:[NSString stringWithFormat:@"%@#more-%ld", self.post.url, (long)self.post.postId]]) {
            __weak typeof(self) weakSelf = self;
            
            [self.webView stringByEvaluatingJavaScriptFromString:@"loadingMore()"];
            
            [NSURLSessionDataTask fetchPostWithId:self.post.postId
                                        withBlock:^(CBPWordPressPost *post, NSError *error) {
                                            if (!error) {
                                                __strong typeof(weakSelf) strongSelf = weakSelf;
                                                
                                                strongSelf.post = post;
                                                
                                                [strongSelf displayPost];
                                                
                                                strongSelf.scrollToMore = YES;
                                            } else {
                                                NSLog(@"Error: %@", error);
                                            }
                                        }];
            
            //Capture links to other posts
        } else if ([[[request URL] host] hasSuffix:CBPSiteURL] && [[[request URL] path] hasPrefix:@"/20"]) {
            CBPPostViewController *vc = [[CBPPostViewController alloc] initWithURL:[request URL]];
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            TOWebViewController *webBrowser = [[TOWebViewController alloc] initWithURL:request.URL];
            [self.navigationController pushViewController:webBrowser animated:YES];
        }
        
        return NO;
	}
    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self canLoadNext]) {
        self.nextTitleLabel.text = [[self.dataSource postAtIndex:(self.index - 1)].titlePlain kv_decodeHTMLCharacterEntities];
    } else {
        self.nextTitleLabel.text = nil;
    }
    
    if ([self canLoadPrevious]) {
        if ((self.index + 1) < [self.dataSource.posts count]) {
            self.previousTitleLabel.text = [[self.dataSource postAtIndex:self.index + 1].titlePlain kv_decodeHTMLCharacterEntities];
        } else if (self.post.previousTitle) {
            self.previousTitleLabel.text = [self.post.previousTitle kv_decodeHTMLCharacterEntities];
        }
    } else {
        self.previousTitleLabel.text = nil;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.scrollToMore) {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"scrollIntoView(%ld)", (long)self.post.postId]];
        
        self.scrollToMore = NO;
        
        if (self.dataSource) {
            [self.dataSource replacePost:self.post];
        }
    }
}

#pragma mark - UIPinchGestureRecognizer
- (void)pinchAction:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if (!self.pinchAllowed && !self.alertShown) {
        self.alertShown = YES;
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:NSLocalizedString(@"If you want to see a larger version of an image, tap on it.\nIf you want to make the text larger by pinching you can enable it below.", nil)
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                          otherButtonTitles:NSLocalizedString(@"Enlarge text", nil), nil] show];
        
        return;
    }
    
    CGFloat pinchScale = gestureRecognizer.scale;
    
    if (pinchScale < 1) {
        self.baseFontSize = self.baseFontSize - (pinchScale / CBPLoadPostViewMultiplier);
    } else {
        self.baseFontSize = self.baseFontSize + (pinchScale / 2);
    }
    
    if (self.baseFontSize < CBPMinimumFontSize) {
        self.baseFontSize = CBPMinimumFontSize;
    } else if (self.baseFontSize >= CBPMaximiumFontSize) {
        self.baseFontSize = CBPMaximiumFontSize;
    }
    
    [[NSUserDefaults standardUserDefaults] setFloat:self.baseFontSize forKey:CBPUserFontSize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"changeFontSize('%f')", self.baseFontSize]];
}

#pragma mark - Observers
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat frameWidth = CGRectGetWidth(self.view.frame);
    CGFloat frameHeight = CGRectGetHeight(self.view.frame);
    
    if ([keyPath isEqualToString:kContentOffsetString])
    {
        if (self.scrollView.contentOffset.y == 0)
        {
            self.nextView.frame = CGRectMake(0, -CBPLoadPostViewHeight, frameWidth, CBPLoadPostViewHeight);
            self.previousView.frame = CGRectMake(0, frameHeight, frameWidth, CBPLoadPostViewHeight);
            return;
        }
        
        if (self.scrollView.contentOffset.y < 0)
        {
            CGFloat offset = self.scrollView.contentOffset.y;
            
            if (offset < -CBPLoadPostViewHeight) {
                offset = -CBPLoadPostViewHeight;
            }
            
            self.nextView.frame = CGRectMake(0, 0 - (CBPLoadPostViewHeight + offset), frameWidth, CBPLoadPostViewHeight);
        }
        else if (frameHeight > (self.scrollView.contentSize.height - self.scrollView.contentOffset.y))
        {
            CGFloat top = (frameHeight - (self.view.frame.size.height - (self.scrollView.contentSize.height - self.scrollView.contentOffset.y)));
            if (top < (frameHeight - CBPLoadPostViewHeight)) {
                top = (frameHeight - CBPLoadPostViewHeight);
            }
            
            self.previousView.frame = CGRectMake(0, top , frameWidth, CBPLoadPostViewHeight);
        }
    }
    else if ([keyPath isEqualToString:kFrameString])
    {
        self.nextView.frame = CGRectMake(0, -CBPLoadPostViewHeight, frameWidth, CBPLoadPostViewHeight);
        self.previousView.frame = CGRectMake(0, self.view.frame.size.height, frameWidth, CBPLoadPostViewHeight);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y <= -CBPLoadPostViewHeight)
    {
        [self loadNextAction];
    }
    else if ((CGRectGetHeight(self.view.frame) - self.previousView.frame.origin.y) >= CBPLoadPostViewHeight)
    {
        [self loadPreviousAction];
    }
}

#pragma mark -
- (UILabel *)nextTitleLabel
{
    if (!_nextTitleLabel) {
        _nextTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CBPLoadPostViewPadding, 0, CGRectGetWidth(self.view.frame) - (CBPLoadPostViewPadding * 2), CBPLoadPostViewHeight)];
        _nextTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _nextTitleLabel.backgroundColor = [UIColor clearColor];
        _nextTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _nextTitleLabel.numberOfLines = 2;
        _nextTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _nextTitleLabel;
}

- (UIView *)nextView
{
    if (!_nextView) {
        _nextView = [[UIView alloc] initWithFrame:CGRectMake(0, -CBPLoadPostViewHeight, CGRectGetWidth(self.view.frame), CBPLoadPostViewHeight)];
        _nextView.translatesAutoresizingMaskIntoConstraints = NO;
        _nextView.backgroundColor = [UIColor colorWithRed:0.964f green:0.964f blue:0.964f alpha:1.0f];
        
        [_nextView addSubview:self.nextTitleLabel];
        
        UIView *bottomBlackLine = [UIView new];
        bottomBlackLine.translatesAutoresizingMaskIntoConstraints = NO;
        bottomBlackLine.backgroundColor = [UIColor lightGrayColor];
        [_nextView addSubview:bottomBlackLine];
        
        NSDictionary *views = @{@"nextTitleLabel": self.nextTitleLabel,
                                @"bottomBlackLine": bottomBlackLine};
        
        NSDictionary *metrics = @{@"padding": @(CBPLoadPostViewPadding)};
        
        [_nextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nextTitleLabel]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [_nextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomBlackLine(1)]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [_nextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[nextTitleLabel]-(padding)-|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:views]];
        [_nextView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[bottomBlackLine]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        
        _nextView.hidden = YES;
    }
    
    return _nextView;
}

- (UILabel *)previousTitleLabel
{
    if (!_previousTitleLabel) {
        _previousTitleLabel = [UILabel new];
        _previousTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _previousTitleLabel.backgroundColor = [UIColor clearColor];
        _previousTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _previousTitleLabel.numberOfLines = 2;
        _previousTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _previousTitleLabel;
}

- (UIView *)previousView
{
    if (!_previousView) {
        _previousView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), CBPLoadPostViewHeight)];
        _previousView.translatesAutoresizingMaskIntoConstraints = NO;
        _previousView.backgroundColor = [UIColor colorWithRed:0.964f green:0.964f blue:0.964f alpha:1.0f];
        
        [_previousView addSubview:self.previousTitleLabel];
        
        UIView *topBlackLine = [UIView new];
        topBlackLine.translatesAutoresizingMaskIntoConstraints = NO;
        topBlackLine.backgroundColor = [UIColor lightGrayColor];
        [_previousView addSubview:topBlackLine];
        
        NSDictionary *views = @{@"previousTitleLabel": self.previousTitleLabel,
                                @"topBlackLine": topBlackLine};
        
        NSDictionary *metrics = @{@"padding": @(CBPLoadPostViewPadding)};
        
        [_previousView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[previousTitleLabel]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
        [_previousView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topBlackLine(1)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
        [_previousView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[previousTitleLabel]-(padding)-|"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:views]];
        [_previousView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[topBlackLine]|"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:views]];
        _previousView.hidden = YES;
    }
    
    return _previousView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        //this is to allow video to use sound even if the mute button is toggled
        //via: http://stackoverflow.com/a/12414719/806442
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        BOOL ok;
        NSError *setCategoryError = nil;
        ok = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                 error:&setCategoryError];
        if (!ok) {
            NSLog(@"%s setCategoryError=%@", __PRETTY_FUNCTION__, setCategoryError);
        }
        
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = YES;
        _webView.delegate = self;
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(pinchAction:)];
        
        [_webView addGestureRecognizer:pinch];
    }
    
    return _webView;
}
@end
