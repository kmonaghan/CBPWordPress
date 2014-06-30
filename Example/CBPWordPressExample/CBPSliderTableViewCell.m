//
//  CBPSliderTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 30/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPSliderTableViewCell.h"

@implementation CBPSliderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSlider:(UISlider *)slider
{
    _slider = slider;
    _slider.frame = CGRectMake(CBPPadding, ceilf((CBPSliderTableViewCellHeight - CGRectGetHeight(slider.frame)) / 2), CGRectGetWidth(self.contentView.frame) - (CBPPadding * 2), CGRectGetHeight(slider.frame));
    
    [self.contentView addSubview:_slider];
}
@end
