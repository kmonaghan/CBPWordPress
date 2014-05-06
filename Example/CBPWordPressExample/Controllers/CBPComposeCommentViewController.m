//
//  CBPComposeCommentViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPComposeCommentViewController.h"

@interface CBPComposeCommentViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (assign, nonatomic) BOOL constraintsCreated;
@property (copy, nonatomic) commentCompletionBlock completionBlock;
@property (strong, nonatomic) UITextView *commentTextView;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (assign, nonatomic) NSInteger postId;
@property (strong, nonatomic) UITextField *urlTextField;
@end

@implementation CBPComposeCommentViewController

- (instancetype)initWithPostId:(NSInteger)postId withCompletionBlock:(commentCompletionBlock)block
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        _postId = postId;
        _completionBlock = block;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (!self.constraintsCreated) {
        NSDictionary *views = @{@"topLayoutGuide": self.topLayoutGuide,
                                @"nameTextField": self.nameTextField,
                                @"emailTextField": self.emailTextField,
                                @"urlTextField": self.urlTextField,
                                @"commentTextView": self.commentTextView};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[nameTextField]-[emailTextField]-[urlTextField]-[commentTextView(200)]"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[nameTextField]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[emailTextField]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[urlTextField]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[commentTextView]-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:views]];
        self.constraintsCreated = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                                           target:self
                                                                                           action:@selector(replyAction)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (void)cancelAction
{
    self.completionBlock(nil, nil);
}

- (void)replyAction
{
    [self syncDetails];
    
    __weak typeof(self) blockSelf = self;
    
    CBPWordPressComment *newComment = [CBPWordPressComment new];
    newComment.postId = self.postId;
    newComment.email = self.emailTextField.text;
    newComment.name = self.nameTextField.text;
    newComment.content = self.commentTextView.text;
    
    if ([self.urlTextField.text length]) {
        newComment.url = self.urlTextField.text;
    }
    
    [NSURLSessionDataTask postComment:newComment
                            withBlock:^(CBPWordPressComment *comment, NSError *error){
                                NSLog(@"%@", [comment dictionaryRepresentation]);
                                
                                if (comment) {
                                    blockSelf.completionBlock(comment, nil);
                                }
                            }];
}

#pragma mark -
- (void)syncDetails
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.nameTextField.text forKey:@"comment_name"];
    [defaults setObject:self.emailTextField.text forKey:@"comment_email"];
    
    if ([self.urlTextField.text length])
    {
        [defaults setObject:self.urlTextField.text forKey:@"comment_url"];
    }
    
    [defaults synchronize];
}

#pragma mark - Getters
- (UITextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField = [UITextField new];
        _emailTextField.borderStyle = UITextBorderStyleRoundedRect;
        _emailTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _emailTextField.placeholder = NSLocalizedString(@"Email Address", @"Placeholder for commenter's email textfield");
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.delegate = self;
        
        [self.view addSubview:_emailTextField];
    }
    return _emailTextField;
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _nameTextField.placeholder = NSLocalizedString(@"Your name", @"Placeholder for commenter's name textfield");
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _nameTextField.delegate = self;
        
        [self.view addSubview:_nameTextField];
    }
    return _nameTextField;
}

- (UITextView *)commentTextView
{
    if (!_commentTextView) {
        _commentTextView = [UITextView new];
        _commentTextView.font = [UIFont systemFontOfSize:17.0f];
        _commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _commentTextView.layer.cornerRadius = 4.0f;
        
        [self.view addSubview:_commentTextView];
    }
    
    return _commentTextView;
}

- (UITextField *)urlTextField
{
    if (!_urlTextField) {
        _urlTextField = [UITextField new];
        _urlTextField.borderStyle = UITextBorderStyleRoundedRect;
        _urlTextField.translatesAutoresizingMaskIntoConstraints = NO;
        _urlTextField.placeholder = NSLocalizedString(@"Your website", @"Placeholder for commenter's website textfield");
        _urlTextField.returnKeyType = UIReturnKeyNext;
        _urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _urlTextField.delegate = self;
        
        [self.view addSubview:_urlTextField];
    }
    return _urlTextField;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
    } else if (textField == self.emailTextField) {
        [self.urlTextField becomeFirstResponder];
    } else if (textField == self.urlTextField) {
        [self.commentTextView becomeFirstResponder];
    }
    
    return YES;
}
@end
