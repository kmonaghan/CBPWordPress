//
//  CBPSettingsViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 24/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "BButton.h"
#import "CBPAppDelegate.h"
#import "HTEmailAutocompleteTextField.h"

#import "CBPSettingsViewController.h"

#import "CBPSliderTableViewCell.h"
#import "CBPTextFieldTableViewCell.h"

static NSString * const CBPSwitchTableViewCellIdentifier = @"CBPSwitchTableViewCellIdentifier";

@interface CBPSettingsViewController () <UITextFieldDelegate>
@property (nonatomic) UISwitch *backgroundSwitch;
@property (nonatomic) HTAutocompleteTextField *emailTextField;
@property (nonatomic) UIView *footerView;
@property (nonatomic) UITextField *nameTextField;
@property (nonatomic) UISwitch *reminderSwitch;
@property (nonatomic) BButton *saveButton;
@property (nonatomic) UILabel *sampleTextLabel;
@property (nonatomic) UISwitch *systemFontSwitch;
@property (nonatomic) UISlider *userFontSizeSlider;
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

    [self.tableView registerClass:[CBPSliderTableViewCell class] forCellReuseIdentifier:CBPSliderTableViewCellIdentifier];
    [self.tableView registerClass:[CBPTextFieldTableViewCell class] forCellReuseIdentifier:CBPTextFieldTableViewCellIdentifier];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.nameTextField.text = [defaults objectForKey:CBPCommenterName];
    self.emailTextField.text = [defaults objectForKey:CBPCommenterEmail];
    self.urlTextField.text = [defaults objectForKey:CBPCommenterURL];
    
    self.backgroundSwitch = [UISwitch new];
    self.reminderSwitch = [UISwitch new];
    self.systemFontSwitch = [UISwitch new];
    [self.systemFontSwitch addTarget:self action:@selector(systemFontValueChanged) forControlEvents:UIControlEventValueChanged];
    
    self.backgroundSwitch.on = [defaults boolForKey:CBPBackgroundUpdate];
    self.systemFontSwitch.on = ([defaults floatForKey:CBPUserFontSize]) ? NO : YES;
    
    self.userFontSizeSlider.value = ([defaults floatForKey:CBPUserFontSize])? [defaults floatForKey:CBPUserFontSize] : CBPMinimumFontSize;
}

#pragma mark -
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
    
    UIApplication *application = [UIApplication sharedApplication];
    
    if (self.backgroundSwitch.on) {
        [application setMinimumBackgroundFetchInterval:CBPBackgroundFetchInterval];
    } else {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    }

    [defaults setBool:self.backgroundSwitch.on forKey:CBPBackgroundUpdate];
    
    if (self.systemFontSwitch.on) {
        [defaults removeObjectForKey:CBPUserFontSize];
    } else {
        [defaults setFloat:self.userFontSizeSlider.value forKey:CBPUserFontSize];
    }

    [defaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)systemFontValueChanged
{
    [self.tableView beginUpdates];
    
    if (self.systemFontSwitch.on) {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];

    if (!self.systemFontSwitch.on) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
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
        case 1:
            return (self.systemFontSwitch.on) ? 2 : 3;
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
            return NSLocalizedString(@"Comment details", nil);
            break;
        case 1:
            return NSLocalizedString(@"Content", nil);
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
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 3) {
            CBPSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CBPSliderTableViewCellIdentifier];
            cell.slider = self.userFontSizeSlider;
            
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CBPSwitchTableViewCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CBPSwitchTableViewCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = NSLocalizedString(@"Refresh in the background", nil);
                cell.accessoryView = self.backgroundSwitch;
            }
                break;
            case 1:
            {
                cell.textLabel.text = NSLocalizedString(@"Use iOS dynamic font sizes", nil);
                cell.accessoryView = self.systemFontSwitch;
            }
                break;
            default:
                break;
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ((indexPath.section == 1) && (indexPath.row == 3)) {
        return CBPSliderTableViewCellHeight;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
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
    } else if (textField == self.emailTextField) {
        [self.urlTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
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
    if (!_saveButton) {
        _saveButton = [[BButton alloc] initWithFrame:CGRectMake(CBPPadding, 3.0f, CGRectGetWidth(self.view.frame) - (CBPPadding * 2), 44.0f)
                                                type:BButtonTypePrimary
                                               style:BButtonStyleBootstrapV3];
        [_saveButton setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _saveButton;
}

- (UISlider *)userFontSizeSlider
{
    if (!_userFontSizeSlider) {
        _userFontSizeSlider = [UISlider new];
        
        _userFontSizeSlider.minimumValue = CBPMinimumFontSize;
        _userFontSizeSlider.maximumValue = CBPMaximiumFontSize;
                
        UILabel *smallLabel = [UILabel new];
        smallLabel.font = [UIFont systemFontOfSize:CBPMinimumFontSize];
        smallLabel.text = @"A";
        [smallLabel sizeToFit];
        
        UIGraphicsBeginImageContextWithOptions(smallLabel.frame.size, NO, 0.0);
        [smallLabel.layer renderInContext: UIGraphicsGetCurrentContext()];
        _userFontSizeSlider.minimumValueImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UILabel *largeLabel = [UILabel new];
        largeLabel.font = [UIFont systemFontOfSize:CBPMaximiumFontSize];
        largeLabel.text = @"A";
        [largeLabel sizeToFit];
        
        UIGraphicsBeginImageContextWithOptions(largeLabel.frame.size, NO, 0.0);
        [largeLabel.layer renderInContext: UIGraphicsGetCurrentContext()];
        _userFontSizeSlider.maximumValueImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return _userFontSizeSlider;
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
