//
//  CBPPostViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 22/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "JBWhatsAppActivity.h"
#import "GPPShareActivity.h"
#import "MHGallery.h"
#import "TOWebViewController.h"

#import "CBPCommentsViewController.h"
#import "CBPComposeCommentViewController.h"
#import "CBPPostViewController.h"

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.post) {
        [self.navigationController setToolbarHidden:NO animated:YES];
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
    NSMutableArray *buttons = @[].mutableCopy;
    
    if ([self.post.commentStatus isEqualToString:@"open"]) {
        UIBarButtonItem *makeComment = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                     target:self
                                                                                     action:@selector(composeCommentAction)];
        [buttons addObject:makeComment];
        
        [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    }
    
    if (self.post.commentCount) {
        UIBarButtonItem *viewComments = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                                      target:self
                                                                                      action:@selector(viewCommentAction)];
        [buttons addObject:viewComments];
        
        [buttons addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    }
    
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                           target:self
                                                                           action:@selector(sharePostAction)];
    [buttons addObject:share];
    
    [self setToolbarItems:buttons animated:YES];
}

#pragma mark -
- (void)displayPost
{
    [self.webView loadHTMLString:[self.post generateHtml:self.baseFontSize] baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
    [self toolbarButtons];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

#pragma mark - Button Actions
- (void)composeCommentAction
{
    __weak typeof(self) blockSelf = self;
    
    CBPComposeCommentViewController *vc = [[CBPComposeCommentViewController alloc] initWithPostId:self.post.postId
                                                                              withCompletionBlock:^(CBPWordPressComment *comment, NSError *error) {
                                                                                  [blockSelf.navigationController dismissViewControllerAnimated:YES
                                                                                                                                     completion:^() {
                                                                                      
                                                                                      if (error) {
                                                                                          
                                                                                      } else if (comment) {
                                                                                          
                                                                                      }}];
                                                                              }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)sharePostAction
{
    WhatsAppMessage *whatsappMsg = [[WhatsAppMessage alloc] initWithMessage:[NSString stringWithFormat:@"%@ %@", self.post.title, self.post.url] forABID:nil];
    
    NSArray* activityItems = @[ self.post.title, [NSURL URLWithString:self.post.url], whatsappMsg ];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[[JBWhatsAppActivity new], [GPPShareActivity new]]];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard ];
    
    [self presentViewController:activityViewController animated:YES completion:NULL];
}

- (void)showGallery
{
    NSMutableArray *galleryData = @[].mutableCopy;
    
    for (CBPWordPressAttachment *attachment in self.post.attachments) {
        MHGalleryItem *image = [[MHGalleryItem alloc] initWithURL:attachment.url
                                                      galleryType:MHGalleryTypeImage];
        
        [galleryData addObject:image];
    }

    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
    gallery.galleryItems = galleryData;

    __weak MHGalleryController *blockGallery = gallery;
    
    gallery.finishedCallback = ^(NSUInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode) {
        
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

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
        NSArray *parts = [[[request URL] absoluteString] componentsSeparatedByString:@"."];
        
        NSString *ext = [[parts lastObject] lowercaseString];
        
        if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]
            || [ext isEqualToString:@"png"]
            || [ext isEqualToString:@"gif"]) {
            [self showGallery];
        } else {
            TOWebViewController *webBrowser = [[TOWebViewController alloc] initWithURL:request.URL];
            [self.navigationController pushViewController:webBrowser animated:YES];
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
