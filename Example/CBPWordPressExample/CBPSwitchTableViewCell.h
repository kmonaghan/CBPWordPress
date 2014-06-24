//
//  CBPSwitchTableViewCell.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 24/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CBPSwitchTableViewCellHeight = 44.0;
static NSString * const CBPSwitchTableViewCellIdentifier = @"CBPSwitchTableViewCellIdentifier";

@interface CBPSwitchTableViewCell : UITableViewCell
@property (nonatomic) UISwitch *itemSwitch;
@property (nonatomic) UILabel *switchLabel;
@end
