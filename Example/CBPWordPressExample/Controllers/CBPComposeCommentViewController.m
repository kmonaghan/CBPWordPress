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
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextView *commentTextView;
@property (strong, nonatomic) UITextField *urlTextField;
@end

@implementation CBPComposeCommentViewController

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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    if (!self.constraintsCreated) {
        NSDictionary *views = @{@"topLayoutGuide": self.topLayoutGuide,
                                @"nameTextField": self.nameTextField,
                                @"emailTextField": self.emailTextField,
                                @"urlTextField": self.urlTextField};
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide]-[nameTextField]-[emailTextField]-[urlTextField]"
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

#pragma mark -
- (void)cancelAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)replyAction
{
    
}

#pragma mark -
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
