//
//  CBPSubmitTipViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "BButton.h"
#import "GTMUIImage+Resize.h"
#import "HTEmailAutocompleteTextField.h"
#import "MBProgressHUD.h"
#import "SAMTextView.h"

#import "CBPSubmitTipViewController.h"

#import "CBPTextFieldTableViewCell.h"
#import "CBPTextViewTableViewCell.h"

@interface CBPSubmitTipViewController () <UIActionSheetDelegate,
                                            UIAlertViewDelegate,
                                            UIImagePickerControllerDelegate,
                                            UINavigationControllerDelegate,
                                            UITextFieldDelegate,
                                            UITextViewDelegate>
@property (nonatomic, assign) BOOL askAboutAttachment;
@property (nonatomic) UIImage *attachmentImage;
@property (nonatomic) UIImageView *attachmentImageView;
@property (nonatomic) HTEmailAutocompleteTextField *emailTextField;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) SAMTextView *messageTextView;
@property (nonatomic) UIImagePickerController *picker;
@end

@implementation CBPSubmitTipViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _picker = [UIImagePickerController new];
        _picker.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.nameTextField.text = [defaults objectForKey:CBPCommenterName];
    self.emailTextField.text = [defaults objectForKey:CBPCommenterEmail];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                          target:self
                                                                                          action:@selector(doneAction)];
    
    
    [self.tableView registerClass:[CBPTextFieldTableViewCell class] forCellReuseIdentifier:CBPTextFieldTableViewCellIdentifier];
    [self.tableView registerClass:[CBPTextViewTableViewCell class] forCellReuseIdentifier:CBPTextViewTableViewCellIdentifier];
    
    [self makeFooter];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)doneAction
{
    [[self parentViewController] dismissViewControllerAnimated:YES completion:nil];
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
    
    if (![self.messageTextView.text length]) {
        result = NO;
        [errorMessage appendString:@"Please enter a message"];
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

- (void)submit
{
    self.tableView.tableHeaderView = nil;
    
    if (![self validate]) {
        return;
    }
    
    if (!self.askAboutAttachment && !self.attachmentImage) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Photo?", nil)
                                    message:NSLocalizedString(@"You've not attached a photo and we love pictures. Are you sure you want to submit without one?", nil)
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"Send Tip", nil)
                          otherButtonTitles:NSLocalizedString(@"Attach Photo", nil), nil] show];
        
        self.askAboutAttachment = YES;
        
        return;
    }
    
    [self.view endEditing:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Sending Tip", nil);
    //hud.yOffset = (self.view.$y / 2) - (hud.$y / 2);
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://broadsheet.ie"]];
    NSData *imageData = UIImagePNGRepresentation(self.attachmentImage);
    
    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperation *op = [manager POST:@"/iphone_tip.php"
                                    parameters:@{@"name": self.nameTextField.text,
                                                 @"email": self.emailTextField.text,
                                                 @"message": self.messageTextView.text}
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         //do not put image inside parameters dictionary as I did, but append it!
                         [formData appendPartWithFileData:imageData
                                                     name:@"image"
                                                 fileName:@"tip.png"
                                                 mimeType:@"image/png"];
                     }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                           
                                           MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:strongSelf.view];
                                           [strongSelf.view addSubview:HUD];
                                           
                                           // Set custom view mode
                                           HUD.mode = MBProgressHUDModeCustomView;
                                           
                                           HUD.labelText = NSLocalizedString(@"Thanks!", nil);
                                           
                                           [HUD show:YES];
                                           [HUD hide:YES afterDelay:1];
                                           
                                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                           
                                           [defaults setObject:strongSelf.nameTextField.text forKey:CBPCommenterName];
                                           [defaults setObject:strongSelf.emailTextField.text forKey:CBPCommenterEmail];
                                           
                                           [defaults synchronize];
                                           
                                           [strongSelf reset];
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       }];
    [op start];
}

- (void)makeFooter
{
    self.tableView.tableFooterView = nil;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    
    CGFloat offset = 10.0f;
    
    if (self.attachmentImage) {
        BButton *retakePhoto = [[BButton alloc] initWithFrame:CGRectMake(10, 28, 80, 44)];
        
        [retakePhoto setTitle:@"Retake" forState:UIControlStateNormal];
        [retakePhoto addTarget:self
                        action:@selector(addPhoto)
              forControlEvents:UIControlEventTouchUpInside];
        [retakePhoto setType:BButtonTypeDefault];
        
        [footer addSubview:retakePhoto];
        
        if (!self.attachmentImageView) {
            self.attachmentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110.0f, 0.0f, 100.0f, 100.0f)];
        }
        
        self.attachmentImageView.image = self.attachmentImage;
        
        offset = 55.0f;
        
        [footer addSubview:self.attachmentImageView];
        
        BButton *removePhoto = [[BButton alloc] initWithFrame:CGRectMake(230.0f, 28.0f, 80.0f, 44.0f)];
        
        [removePhoto setTitle:@"Remove" forState:UIControlStateNormal];
        [removePhoto addTarget:self
                        action:@selector(removePhoto)
              forControlEvents:UIControlEventTouchUpInside];
        [removePhoto setType:BButtonTypeDanger];
        
        [footer addSubview:removePhoto];
        
    } else {
        BButton *addPhoto = [[BButton alloc] initWithFrame:CGRectMake(10, 3, 300, 44)];
        
        [addPhoto setTitle:@"Add Photo" forState:UIControlStateNormal];
        [addPhoto addTarget:self
                     action:@selector(addPhoto)
           forControlEvents:UIControlEventTouchUpInside];
        [addPhoto setType:BButtonTypeDefault];
        
        [footer addSubview:addPhoto];
    }
    
    BButton *submit = [[BButton alloc] initWithFrame:CGRectMake(10.0f, 50.0f + offset, 300.0f, 44.0f)];
    
    [submit setTitle:@"Submit Tip" forState:UIControlStateNormal];
    [submit addTarget:self
               action:@selector(submit)
     forControlEvents:UIControlEventTouchUpInside];
    [submit setType:BButtonTypePrimary];
    
    [footer addSubview:submit];
    
    footer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100.0f + offset);
    
    self.tableView.tableFooterView = footer;
}

- (void)addPhoto
{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:@"Take Photo"];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [actionSheet addButtonWithTitle:@"From Photo Library"];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [actionSheet addButtonWithTitle:@"From Album"];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    [actionSheet showInView:self.view];
}

- (void)removePhoto
{
    self.attachmentImage = nil;
    self.attachmentImageView = nil;
    
    [self makeFooter];
}

- (void)displayPicker:(UIImagePickerControllerSourceType)source
{
    self.picker.sourceType = source;
    
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)reset
{
    self.messageTextView.text = nil;
    self.attachmentImage = nil;
    
    self.askAboutAttachment = NO;
    
    [self makeFooter];
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    self.attachmentImage = [[info objectForKey:UIImagePickerControllerOriginalImage] gtm_imageByResizingToSize:CGSizeMake(800.0f, 800.0f)
                                                                                           preserveAspectRatio:YES
                                                                                                     trimToFit:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self makeFooter];
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        CBPTextViewTableViewCell *cell = (CBPTextViewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CBPTextViewTableViewCellIdentifier];
        
        cell.inputTextView = self.messageTextView;
        
        return cell;
    }
    
    CBPTextFieldTableViewCell *cell = (CBPTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CBPTextFieldTableViewCellIdentifier];
    
    switch (indexPath.row) {
        case 0:
            cell.inputTextField = self.nameTextField;
            break;
        case 1:
            cell.inputTextField = self.emailTextField;
            break;
        default:
            break;
    }
    return cell;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
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
            [self.messageTextView becomeFirstResponder];
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType source;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Photo"]) {
        source = UIImagePickerControllerSourceTypeCamera;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"From Photo Library"]) {
        source = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"From Album"]) {
        source = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        return;
    }
    
    [self displayPicker:source];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.emailTextField) {
        [self.messageTextView becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        [self submit];
        
        return;
    }
    
    [self addPhoto];
}

#pragma mark -
- (HTEmailAutocompleteTextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField = [HTEmailAutocompleteTextField new];
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.placeholder = NSLocalizedString(@"Your email address", @"The tip submitters email address");
        _emailTextField.delegate = self;
        _emailTextField.backgroundColor = [UIColor clearColor];
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.autocompleteDisabled = NO;
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
    return _emailTextField;
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.placeholder= NSLocalizedString(@"Your name", @"The tip submitters name");
        _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.delegate = self;
    }
    
    return _nameTextField;
}

- (UITextView *)messageTextView
{
    if (!_messageTextView) {
        _messageTextView = [SAMTextView new];
        _messageTextView.backgroundColor = [UIColor clearColor];
        _messageTextView.font = self.emailTextField.font;
        _messageTextView.contentInset = UIEdgeInsetsMake(5.0f, CBPPadding, 5.0f, CBPPadding);
        _messageTextView.placeholder = NSLocalizedString(@"What have you got for us?", @"Placeholder text for the tip submission");
    }
    
    return _messageTextView;
}

@end
