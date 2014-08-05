//
//  CBPTextFieldTableViewCell.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CBPTextFieldTableViewCellHeight = 44.0;
static NSString * const CBPTextFieldTableViewCellIdentifier = @"CBPTextFieldTableViewCellIdentifier";

@interface CBPTextFieldTableViewCell : UITableViewCell
@property (nonatomic) UITextField *inputTextField;
@property (nonatomic) NSString *imageURI;
@end
