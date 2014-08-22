//
//  CBPSliderTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 30/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPSliderTableViewCell.h"

@interface CBPSliderTableViewCell()
@property (nonatomic) UILabel *exampleLabel;
@end

@implementation CBPSliderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.exampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CBPPadding, 0, CGRectGetWidth(self.contentView.frame) - (CBPPadding * 2), 132.0f)];
        self.exampleLabel.text = NSLocalizedString(@"Move the slider to change the text size used in a post", nil);
        self.exampleLabel.numberOfLines = 3;
        self.exampleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.exampleLabel];
    }
    return self;
}

#pragma mark -
- (void)sliderChangedAction
{
    self.exampleLabel.font = [UIFont systemFontOfSize:self.slider.value];
}

#pragma mark -
- (void)setSlider:(UISlider *)slider
{
    _slider = slider;
    _slider.frame = CGRectMake(CBPPadding, ceilf((44.0f - CGRectGetHeight(slider.frame)) / 2) + CGRectGetHeight(self.exampleLabel.frame), CGRectGetWidth(self.contentView.frame) - (CBPPadding * 2), CGRectGetHeight(slider.frame));

    [_slider addTarget:self action:@selector(sliderChangedAction) forControlEvents:UIControlEventValueChanged];

    [self.contentView addSubview:_slider];
    
    [self sliderChangedAction];
}
@end
