//
//  CBPTextFieldTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPTextFieldTableViewCell.h"

@implementation CBPTextFieldTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setInputTextField:(UITextField *)inputTextField
{
    _inputTextField = inputTextField;
    _inputTextField.frame = CGRectMake(CBPPadding, 7.0f, CGRectGetWidth(self.contentView.frame) - (CBPPadding * 2), 30.0f);

    [self.contentView addSubview:_inputTextField];
}
@end
