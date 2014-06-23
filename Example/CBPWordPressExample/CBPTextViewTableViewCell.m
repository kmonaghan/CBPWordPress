//
//  CBPTextViewTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPTextViewTableViewCell.h"

@implementation CBPTextViewTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.inputView];
}
@end
