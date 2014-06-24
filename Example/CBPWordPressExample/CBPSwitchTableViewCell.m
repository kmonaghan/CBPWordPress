//
//  CBPSwitchCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 24/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPSwitchTableViewCell.h"

@interface CBPSwitchTableViewCell()
@property (nonatomic, assign) BOOL didUpdateConstraints;
@end

@implementation CBPSwitchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraints) {
        
        NSDictionary *views = @{@"switchLabel": self.switchLabel,
                                @"itemSwitch": self.itemSwitch};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-(%f)-[switchLabel][itemSwitch]-(%f)-|", CBPPadding, CBPPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        self.didUpdateConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.switchLabel.text = nil;
    self.itemSwitch.on = YES;
}

#pragma mark -
- (UISwitch *)itemSwitch
{
    if (!_itemSwitch) {
        _itemSwitch = [UISwitch new];
        _itemSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_itemSwitch];
    }
    
    return _itemSwitch;
}

- (UILabel *)switchLabel
{
    if (!_switchLabel) {
        _switchLabel = [UILabel new];
        _switchLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _switchLabel;
}
@end
