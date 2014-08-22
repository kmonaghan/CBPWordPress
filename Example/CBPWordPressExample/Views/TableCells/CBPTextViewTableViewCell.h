//
//  CBPTextViewTableViewCell.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CBPTextViewTableViewCellHeight = 132.0;
static NSString * const CBPTextViewTableViewCellIdentifier = @"CBPTextViewTableViewCellIdentifier";

@interface CBPTextViewTableViewCell : UITableViewCell
@property (nonatomic) UITextView *inputTextView;
@end
