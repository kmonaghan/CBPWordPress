//
//  CBPPostViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 22/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "KINWebBrowserViewController.h"

#import "CBPPostViewController.h"

#import "CBPWordPressPost.h"

@interface CBPPostViewController () <UIWebViewDelegate>
@property (assign, nonatomic) CGFloat baseFontSize;
@property (strong, nonatomic) CBPWordPressPost *post;
@property (strong, nonatomic) UIWebView *webView;
@end

@implementation CBPPostViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _baseFontSize = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody].pointSize;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
	// Do any additional setup after loading the view.
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.delegate = self;
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(pinchAction:)];
    
    [self.webView addGestureRecognizer:pinch];
    
    [self.view addSubview:self.webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.post) {
        [self displayPost];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];

    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)toolbarButtons
{
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(sharePostAction)];
    [self setToolbarItems:@[share] animated:YES];
}

#pragma mark - 
- (void)displayPost
{
    [self.webView loadHTMLString:[self.post generateHtml:self.baseFontSize] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    [self toolbarButtons];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark - Button Actions
- (void)sharePostAction
{
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
        NSArray *parts = [[[request URL] absoluteString] componentsSeparatedByString:@"."];
        
        NSString *ext = [[parts lastObject] lowercaseString];
        
        if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]
            || [ext isEqualToString:@"png"]
            || [ext isEqualToString:@"gif"])
        {
            //TODO: Handle showing gallery
        }
        else
        {
            KINWebBrowserViewController *webBrowser = [KINWebBrowserViewController webBrowser];
            [self.navigationController pushViewController:webBrowser animated:YES];
            [webBrowser loadURL:request.URL];
        }
        
        return NO;
	}
    
	return YES;
}

#pragma mark - UIPinchGestureRecognizer
- (void)pinchAction:(UIPinchGestureRecognizer *)gestureRecognizer
{
    CGFloat pinchScale = gestureRecognizer.scale;
    
    if (pinchScale < 1)
    {
        self.baseFontSize = self.baseFontSize - (pinchScale / 1.5f);
    }
    else
    {
        self.baseFontSize = self.baseFontSize + (pinchScale / 2);
    }
    
    if (self.baseFontSize < 16.0f)
    {
        self.baseFontSize = 16.0f;
    }
    else if (self.baseFontSize >= 32.0f)
    {
        self.baseFontSize = 32.0f;
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"changeFontSize('%f')", self.baseFontSize]];
}
@end
