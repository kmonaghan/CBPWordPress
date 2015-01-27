//
//  CBPSubmitTipViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "BButton.h"
#import "HTEmailAutocompleteTextField.h"
#import "HTProgressHUD.h"
#import "MHGallery.h"
#import "SAMTextView.h"
#import "UIImage+Resize.h"

#import "CBPSubmitTipViewController.h"

#import "CBPTextFieldTableViewCell.h"
#import "CBPTextViewTableViewCell.h"

@interface CBPSubmitTipViewController () <UIActionSheetDelegate,
UIAlertViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UITextFieldDelegate,
UITextViewDelegate>
@property (nonatomic) BButton *addPhoto;
@property (nonatomic, assign) BOOL askAboutAttachment;
@property (nonatomic) UIImage *attachmentImage;
@property (nonatomic) UIImageView *attachmentImageView;
@property (nonatomic, assign) CGFloat currentTextViewHeight;
@property (nonatomic) HTEmailAutocompleteTextField *emailTextField;
@property (nonatomic) HTProgressHUD *hud;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) SAMTextView *messageTextView;
@property (nonatomic) UIImagePickerController *picker;
@property (nonatomic) BButton *removePhoto;
@property (nonatomic) BButton *retakePhoto;
@property (nonatomic) BButton *submit;
@property (nonatomic) UIButton *viewImage;
@end

@implementation CBPSubmitTipViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _picker = [UIImagePickerController new];
        _picker.delegate = self;
        _currentTextViewHeight = CBPTextViewTableViewCellHeight;
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
        
        [errorMessage appendString:NSLocalizedString(@"Please enter your name\n", nil)];
    }
    
    if (![self.emailTextField.text length]) {
        result = NO;
        [errorMessage appendString:NSLocalizedString(@"Please enter an email address\n", nil)];
    }
    
    if (![self.messageTextView.text length]) {
        result = NO;
        [errorMessage appendString:NSLocalizedString(@"Please enter a message", nil)];
    }
    
    if (!result){
        UILabel *errorLabel = [UILabel new];
        errorLabel.text = errorMessage;
        errorLabel.numberOfLines = 0;
        errorLabel.frame = CGRectMake(CBPPadding, CBPPadding, CGRectGetWidth(self.view.frame) - (CBPPadding * 2), 22.0f);
        [errorLabel sizeToFit];
        errorLabel.backgroundColor = [UIColor clearColor];
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), errorLabel.frame.size.height + 20.0f)];
        
        [header addSubview:errorLabel];
        
        self.tableView.tableHeaderView = header;
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    return result;
}

- (void)submitAction
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
    
    self.submit.enabled = NO;
    self.retakePhoto.enabled = NO;
    self.removePhoto.enabled = NO;
    self.addPhoto.enabled = NO;
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://broadsheet.ie"]];
    NSData *imageData = UIImagePNGRepresentation(self.attachmentImage);
    
    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperation *op = [manager POST:@"/iphone_tip_karl.php"
                                    parameters:@{@"name": self.nameTextField.text,
                                                 @"email": self.emailTextField.text,
                                                 @"message": self.messageTextView.text}
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         if (imageData) {
                             [formData appendPartWithFileData:imageData
                                                         name:@"image"
                                                     fileName:@"tip.png"
                                                     mimeType:@"image/png"];
                         }
                     }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           
                                           [strongSelf.hud hideWithAnimation:YES];
                                           
                                           HTProgressHUD *hud = [HTProgressHUD new];
                                           hud.indicatorView = nil;
                                           hud.textLabel.text = NSLocalizedString(@"Thanks!", nil);
                                           [hud showInView:strongSelf.view animated:NO];
                                           [hud hideAfterDelay:3];
                                           
                                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                           
                                           [defaults setObject:strongSelf.nameTextField.text forKey:CBPCommenterName];
                                           [defaults setObject:strongSelf.emailTextField.text forKey:CBPCommenterEmail];
                                           
                                           [defaults synchronize];
                                           
                                           [strongSelf reset];
                                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           
                                           [strongSelf.hud hideWithAnimation:YES];
                                           
                                           [strongSelf showError:error.localizedDescription];
                                           
                                           strongSelf.submit.enabled = YES;
                                           strongSelf.retakePhoto.enabled = YES;
                                           strongSelf.removePhoto.enabled = YES;
                                           strongSelf.addPhoto.enabled = YES;
                                       }];
    [op start];
    
    self.hud = [HTProgressHUD new];
    [self.hud showInView:self.view animated:YES];
    self.hud.textLabel.text = NSLocalizedString(@"Sending Tip", nil);
}

- (void)makeFooter
{
    self.tableView.tableFooterView = nil;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    footer.backgroundColor = [UIColor clearColor];
    
    [footer addSubview:self.submit];
    
    NSMutableDictionary *views = @{@"submit": self.submit}.mutableCopy;
    
    NSDictionary *metrics = @{@"imageHeight": @(160),
                              @"minHeight": @(44),
                              @"padding": @(CBPPadding)};
    
    [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[submit]-(padding)-|"
                                                                   options:0
                                                                   metrics:metrics
                                                                     views:views]];
    if (self.attachmentImage) {
        [footer addSubview:self.retakePhoto];
        
        [footer addSubview:self.attachmentImageView];
        
        [footer addSubview:self.removePhoto];
        
        [footer addSubview:self.viewImage];
        
        views[@"retakePhoto"] = self.retakePhoto;
        views[@"attachmentImageView"] = self.attachmentImageView;
        views[@"removePhoto"] = self.removePhoto;
        views[@"viewImage"] = self.viewImage;
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[attachmentImageView(imageHeight)]-(10)-[retakePhoto]-(10)-[submit(minHeight)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[viewImage(imageHeight)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[retakePhoto(minHeight)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[removePhoto(minHeight)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[attachmentImageView]-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[viewImage]-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        [footer addConstraint:[NSLayoutConstraint constraintWithItem:self.attachmentImageView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:footer
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0f
                                                            constant:0]];
        
        [footer addConstraint:[NSLayoutConstraint constraintWithItem:self.removePhoto
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.retakePhoto
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0f
                                                            constant:0]];
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[retakePhoto(==removePhoto)]-[removePhoto]-(padding)-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        self.attachmentImageView.image = self.attachmentImage;
    } else {
        [footer addSubview:self.addPhoto];
        
        views[@"addPhoto"] = self.addPhoto;
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[addPhoto(minHeight)]-[submit(minHeight)]"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
        
        [footer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(padding)-[addPhoto]-(padding)-|"
                                                                       options:0
                                                                       metrics:metrics
                                                                         views:views]];
    }
    
    [footer layoutIfNeeded];
    
    footer.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.submit.frame) + 10.0f);
    
    self.tableView.tableFooterView = footer;
}

- (void)addPhotoAction
{
    [self.view endEditing:YES];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"Take Photo", nil)];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"From Photo Library", nil)];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"From Album", nil)];
    }
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
    
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    
    [actionSheet showInView:self.view];
}

- (void)removePhotoAction
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
    
    self.submit.enabled = YES;
    self.retakePhoto.enabled = YES;
    self.removePhoto.enabled = YES;
    self.addPhoto.enabled = YES;
    
    [self makeFooter];
}

- (void)showImageAction
{
    NSArray *galleryData = @[[[MHGalleryItem alloc] initWithImage:self.attachmentImage]];
    
    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarHidden];
    gallery.galleryItems = galleryData;
    gallery.presentingFromImageView = self.attachmentImageView;
    
    MHUICustomization *viewCustomization = [MHUICustomization new];
    viewCustomization.showOverView = NO;
    viewCustomization.hideShare = YES;
    
    gallery.UICustomization = viewCustomization;
    
    __weak MHGalleryController *blockGallery = gallery;
    
    gallery.finishedCallback = ^(NSInteger currentIndex, UIImage *image, MHTransitionDismissMHGallery *interactiveTransition, MHGalleryViewMode viewMode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockGallery dismissViewControllerAnimated:YES dismissImageView:nil completion:nil];
        });
        
    };
    
    [self presentMHGalleryController:gallery animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    self.attachmentImage = [[info objectForKey:UIImagePickerControllerOriginalImage] resizedImageToFitInSize:CGSizeMake(1000.0f, 1000.0f) scaleIfSmaller:NO];
    
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
        return self.currentTextViewHeight;
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
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"Take Photo", nil)]) {
        source = UIImagePickerControllerSourceTypeCamera;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"From Photo Library", nil)]) {
        source = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:NSLocalizedString(@"From Album", nil)]) {
        source = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else {
        return;
    }
    
    [self displayPicker:source];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!self.submit.enabled) {
        return NO;
    }
    
    if (textField == self.nameTextField) {
        [self.emailTextField becomeFirstResponder];
        return NO;
    } else if (textField == self.emailTextField) {
        [self.messageTextView becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView;
{
    if (!self.submit.enabled) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        [self submitAction];
        
        return;
    }
    
    [self addPhoto];
}

#pragma mark -
- (BButton *)addPhoto
{
    if (!_addPhoto){
        _addPhoto = [[BButton alloc] initWithFrame:CGRectZero];
        _addPhoto.translatesAutoresizingMaskIntoConstraints = NO;
        [_addPhoto setTitle:NSLocalizedString(@"Add Photo", nil) forState:UIControlStateNormal];
        [_addPhoto addTarget:self
                      action:@selector(addPhotoAction)
            forControlEvents:UIControlEventTouchUpInside];
        [_addPhoto setType:BButtonTypeDefault];
    }
    
    return _addPhoto;
}

- (UIImageView *)attachmentImageView
{
    if (!_attachmentImageView) {
        _attachmentImageView = [UIImageView new];
        _attachmentImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _attachmentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _attachmentImageView;
}

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
        _messageTextView.contentInset = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        _messageTextView.delegate = self;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:NSLocalizedString(@"What have you got for us?", @"Placeholder text for the tip submission")];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithWhite:0.8 alpha:1.0f]
                                 range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSFontAttributeName
                                 value:self.emailTextField.font
                                 range:NSMakeRange(0,[attributedString length])];
        
        _messageTextView.attributedPlaceholder = attributedString;
    }
    
    return _messageTextView;
}

- (BButton *)removePhoto
{
    if (!_removePhoto) {
        _removePhoto = [[BButton alloc] initWithFrame:CGRectZero];
        _removePhoto.translatesAutoresizingMaskIntoConstraints = NO;
        [_removePhoto setTitle:NSLocalizedString(@"Remove", nil) forState:UIControlStateNormal];
        [_removePhoto addTarget:self
                         action:@selector(removePhotoAction)
               forControlEvents:UIControlEventTouchUpInside];
        [_removePhoto setType:BButtonTypeDanger];
    }
    
    return _removePhoto;
}

- (BButton *)retakePhoto
{
    if (!_retakePhoto) {
        _retakePhoto = [[BButton alloc] initWithFrame:CGRectZero];
        _retakePhoto.translatesAutoresizingMaskIntoConstraints = NO;
        [_retakePhoto setTitle:NSLocalizedString(@"Retake", nil) forState:UIControlStateNormal];
        [_retakePhoto addTarget:self
                         action:@selector(addPhoto)
               forControlEvents:UIControlEventTouchUpInside];
        [_retakePhoto setType:BButtonTypeDefault];
    }
    
    return _retakePhoto;
}

- (BButton *)submit
{
    if (!_submit) {
        _submit = [[BButton alloc] initWithFrame:CGRectZero];
        _submit.translatesAutoresizingMaskIntoConstraints = NO;
        [_submit setTitle:NSLocalizedString(@"Submit Tip", nil) forState:UIControlStateNormal];
        [_submit addTarget:self
                    action:@selector(submitAction)
          forControlEvents:UIControlEventTouchUpInside];
        [_submit setType:BButtonTypePrimary];
    }
    
    return _submit;
}

- (UIButton *)viewImage
{
    if (!_viewImage) {
        _viewImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewImage.translatesAutoresizingMaskIntoConstraints = NO;
        [_viewImage addTarget:self action:@selector(showImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _viewImage;
}
@end
