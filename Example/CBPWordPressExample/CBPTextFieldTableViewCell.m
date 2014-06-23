//
//  CBPTextFieldTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPTextFieldTableViewCell.h"

@implementation CBPTextFieldTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.inputField];
}
@end
