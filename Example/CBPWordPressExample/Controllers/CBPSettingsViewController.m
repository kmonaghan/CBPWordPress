//
//  CBPSettingsViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 24/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "BButton.h"
#import "HTEmailAutocompleteTextField.h"

#import "CBPSettingsViewController.h"

#import "CBPTextFieldTableViewCell.h"
#import "CBPSwitchTableViewCell.h"

@interface CBPSettingsViewController () <UITextFieldDelegate>
@property (nonatomic) HTAutocompleteTextField *emailTextField;
@property (nonatomic) UIView *footerView;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) BButton *saveButton;
@property (nonatomic) UITextField *urlTextField;
@end

@implementation CBPSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Settings", nil);
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = self.footerView;
    
    [self.tableView registerClass:[CBPTextFieldTableViewCell class] forCellReuseIdentifier:CBPTextFieldTableViewCellIdentifier];
    [self.tableView registerClass:[CBPSwitchTableViewCell class] forCellReuseIdentifier:CBPSwitchTableViewCellIdentifier];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.nameTextField.text = [defaults objectForKey:CBPCommenterName];
    self.emailTextField.text = [defaults objectForKey:CBPCommenterEmail];
    self.urlTextField.text = [defaults objectForKey:CBPCommenterURL];
}

- (void)saveAction:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([self.nameTextField.text length]) {
        [defaults setObject:self.nameTextField.text forKey:CBPCommenterName];
    }
    
    if ([self.emailTextField.text length]) {
        [defaults setObject:self.emailTextField.text forKey:CBPCommenterEmail];
    }
    
    if ([self.urlTextField.text length]) {
        [defaults setObject:self.urlTextField.text forKey:CBPCommenterURL];
    }
    
    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Comment details";
            break;
        case 2:
            return @"Text Size";
            break;
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CBPTextFieldTableViewCell *cell = (CBPTextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CBPTextFieldTableViewCellIdentifier];
        
        switch (indexPath.row) {
            case 0:
                cell.inputTextField = self.nameTextField;
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
        
        return cell;
    }
    else if (indexPath.section == 1)
    {

    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
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
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.nameTextField)
    {
        [self.emailTextField becomeFirstResponder];
        return NO;
    }
    else if (textField == self.emailTextField)
    {
        [self.urlTextField becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark -
- (HTAutocompleteTextField *)emailTextField
{
    if (!_emailTextField) {
        _emailTextField = [HTAutocompleteTextField new];
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.returnKeyType = UIReturnKeyNext;
        _emailTextField.placeholder = NSLocalizedString(@"Your email address", nil);;
        _emailTextField.delegate = self;
        _emailTextField.backgroundColor = [UIColor clearColor];
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.autocompleteDisabled = NO;
    }
    
    return _emailTextField;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50.0f)];
        
        [_footerView addSubview:self.saveButton];
    }
    
    return _footerView;
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [UITextField new];
        _nameTextField.returnKeyType = UIReturnKeyNext;
        _nameTextField.placeholder= NSLocalizedString(@"Your name", nil);
        _nameTextField.delegate = self;
        _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _nameTextField.backgroundColor = [UIColor clearColor];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    
    return _nameTextField;
}

- (BButton *)saveButton
{
    if (_saveButton) {
        _saveButton = [[BButton alloc] initWithFrame:CGRectMake(CBPPadding, 3.0f, CGRectGetWidth(self.view.frame) - (CBPPadding * 2), 44.0f)
                                                type:BButtonTypePrimary
                                               style:BButtonStyleBootstrapV3];
    }
    
    return _saveButton;
}

- (UITextField *)urlTextField
{
    if (!_urlTextField) {
        _urlTextField = [UITextField new];
        _urlTextField.keyboardType = UIKeyboardTypeURL;
        _urlTextField.returnKeyType = UIReturnKeyNext;
        _urlTextField.placeholder = NSLocalizedString(@"Your website", nil);
        _urlTextField.delegate = self;
        _urlTextField.backgroundColor = [UIColor clearColor];
        _urlTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _urlTextField;
}
@end
