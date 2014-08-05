//
//  CBPComposeCommentViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "HTEmailAutocompleteTextField.h"
#import "HTProgressHUD.h"
#import "SAMTextView.h"

#import "CBPComposeCommentViewController.h"

#import "CBPTextFieldTableViewCell.h"
#import "CBPTextViewTableViewCell.h"

@interface CBPComposeCommentViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, copy) commentCompletionBlock completionBlock;
@property (nonatomic) CBPWordPressComment *comment;
@property (nonatomic) SAMTextView *commentTextView;
@property (nonatomic) HTEmailAutocompleteTextField *emailTextField;
@property (nonatomic) HTProgressHUD *hud;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic, assign) NSInteger postId;
@property (nonatomic) UITextField *urlTextField;
@end

@implementation CBPComposeCommentViewController

- (instancetype)initWithPostId:(NSInteger)postId withCompletionBlock:(commentCompletionBlock)block
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        _postId = postId;
        _completionBlock = block;
    }
    return self;
}

- (instancetype)initWithPostId:(NSInteger)postId withComment:(CBPWordPressComment *)comment withCompletionBlock:(commentCompletionBlock)block
{
    self = [self initWithPostId:postId withCompletionBlock:block];
    if (self) {
        // Custom initialization
        _comment = comment;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self updateViewConstraints];
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
    
    [self.tableView registerClass:[CBPTextFieldTableViewCell class] forCellReuseIdentifier:CBPTextFieldTableViewCellIdentifier];
    [self.tableView registerClass:[CBPTextViewTableViewCell class] forCellReuseIdentifier:CBPTextViewTableViewCellIdentifier];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nameTextField.text = [defaults objectForKey:CBPCommenterName];
    self.emailTextField.text = [defaults objectForKey:CBPCommenterEmail];
    self.urlTextField.text = [defaults objectForKey:CBPCommenterURL];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![self.nameTextField.text length]) {
        [self.nameTextField becomeFirstResponder];
    } else if (![self.emailTextField.text length]) {
        [self.emailTextField becomeFirstResponder];
    } else if (![self.urlTextField.text length]) {
        [self.urlTextField becomeFirstResponder];
    } else {
        [self.commentTextView becomeFirstResponder];
    }
}

#pragma mark - Button Actions
- (void)cancelAction
{
    self.completionBlock(nil, nil);
}

- (void)replyAction
{
    self.tableView.tableHeaderView = nil;
    
    if (![self validate]) {
        return;
    }
    
    [self syncDetails];
    
    __weak typeof(self) weakSelf = self;
    
    CBPWordPressComment *newComment = [CBPWordPressComment new];
    newComment.postId = self.postId;
    newComment.email = self.emailTextField.text;
    newComment.name = self.nameTextField.text;
    newComment.content = self.commentTextView.text;
    
    if ([self.urlTextField.text length]) {
        newComment.url = self.urlTextField.text;
    }
    
    if (self.comment) {
        newComment.parent = self.comment.commentId;
    }
    
    self.hud = [HTProgressHUD new];
    [self.hud showInView:self.view animated:YES];
    self.hud.textLabel.text = NSLocalizedString(@"Posting comment", nil);
    
    [NSURLSessionDataTask postComment:newComment
                            withBlock:^(CBPWordPressComment *comment, NSError *error){
                                __strong typeof(weakSelf) strongSelf = weakSelf;
                                
                                [strongSelf.hud hideWithAnimation:YES];
                                
                                if (error) {
                                    [strongSelf showError:NSLocalizedString(@"There was a problem trying to post the comment, try again in a second.", nil)];
                                    
                                    return;
                                }
                                
                                if (strongSelf.comment) {
                                    comment.level = strongSelf.comment.level + 1;
                                }
                                
                                strongSelf.completionBlock(comment, nil);
                                
                            }];
}

- (BOOL)validate
{
    BOOL result = YES;
    NSMutableString *errorMessage = @"".mutableCopy;
    if (![self.nameTextField.text length]) {
        result = NO;
        
        [errorMessage appendString:@"Please enter your name\n"];
    }
    
    if (![self.emailTextField.text length]) {
        result = NO;
        [errorMessage appendString:@"Please enter an email address\n"];
    }
    
    if (![self.commentTextView.text length]) {
        result = NO;
        [errorMessage appendString:@"Please enter a comment"];
    }
    
    if (!result){
        UILabel *errorLabel = [UILabel new];
        errorLabel.text = errorMessage;
        errorLabel.numberOfLines = 0;
        errorLabel.frame = CGRectMake(10, 10, 300, 22);
        [errorLabel sizeToFit];
        errorLabel.backgroundColor = [UIColor clearColor];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, errorLabel.frame.size.height + 20)];
        
        [header addSubview:errorLabel];
        
        self.tableView.tableHeaderView = header;
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    return result;
}

#pragma mark -
- (NSString *)gravatarURI
{
    return [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@.png?s=88", [self md5:self.emailTextField.text]];
}

- (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return  output;
}

- (void)syncDetails
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.nameTextField.text forKey:CBPCommenterName];
    [defaults setObject:self.emailTextField.text forKey:CBPCommenterEmail];
    
    if ([self.urlTextField.text length])
    {
        [defaults setObject:self.urlTextField.text forKey:CBPCommenterURL];
    }
    
    [defaults synchronize];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        CBPTextViewTableViewCell *cell = (CBPTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CBPTextViewTableViewCellIdentifier];
        
        cell.inputTextView = self.commentTextView;
        
        return cell;
    }
    
    CBPTextFieldTableViewCell *cell = (CBPTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CBPTextFieldTableViewCellIdentifier];
    
    switch (indexPath.row) {
        case 0:
        {
            cell.inputTextField = self.nameTextField;
            if ([self.emailTextField.text length]) {
                cell.imageURI = [self gravatarURI];
            }
        }
            break;
        case 1:
            cell.inputTextField = self.emailTextField;
            break;
        case 2:
            cell.inputTextField = self.urlTextField;
            break;
        default:
            break;
    }
    
    [cell updateConstraints];
    
    return cell;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return CBPTextViewTableViewCellHeight;
    }
    
    return CBPTextFieldTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self.nameTextField becomeFirstResponder];
            break;
        case 1:
            [self.emailTextField becomeFirstResponder];
            break;
        case 2:
            [self.urlTextField becomeFirstResponder];
            break;
        case 3:
            [self.commentTextView becomeFirstResponder];
        default:
            break;
    }
}

#pragma mark - Getters
- (HTEmailAutocompleteTextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField = [HTEmailAutocompleteTextField new];
        _emailTextField.backgroundColor = [UIColor whiteColor];
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.placeholder = NSLocalizedString(@"Your email address", @"Placeholder for commenter's email textfield");
        _emailTextField.delegate = self;
        _emailTextField.backgroundColor = [UIColor clearColor];
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.autocompleteDisabled = NO;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        
        [self.view addSubview:_emailTextField];
    }
    return _emailTextField;
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.placeholder = NSLocalizedString(@"Your name", @"Placeholder for commenter's name textfield");
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        _nameTextField.delegate = self;
        
        [self.view addSubview:_nameTextField];
    }
    return _nameTextField;
}

- (SAMTextView *)commentTextView
{
    if (!_commentTextView) {
        _commentTextView = [SAMTextView new];
        _commentTextView.font = self.emailTextField.font;
        _commentTextView.contentInset = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"What have you to say?", @"Placeholder text for the comment submission")];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithWhite:0.8 alpha:1.0f]
                                 range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSFontAttributeName
                                 value:self.emailTextField.font
                                 range:NSMakeRange(0,[attributedString length])];
        
        _commentTextView.attributedPlaceholder = attributedString;
        [self.view addSubview:_commentTextView];
    }
    
    return _commentTextView;
}

- (UITextField *)urlTextField
{
    if (!_urlTextField) {
        _urlTextField = [UITextField new];
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
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else if (textField == self.urlTextField) {
        [self.commentTextView becomeFirstResponder];
    }
    
    return YES;
}
@end
