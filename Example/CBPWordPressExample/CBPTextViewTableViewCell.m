//
//  CBPTextViewTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPTextViewTableViewCell.h"

@implementation CBPTextViewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setInputTextView:(UITextView *)inputTextView
{
    _inputTextView = inputTextView;
    _inputTextView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 122.0f);
    [self.contentView addSubview:inputTextView];
}
@end
