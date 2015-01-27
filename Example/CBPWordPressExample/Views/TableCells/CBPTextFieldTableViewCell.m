//
//  CBPTextFieldTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "CBPTextFieldTableViewCell.h"

@interface CBPTextFieldTableViewCell()
@property (nonatomic, assign) BOOL didUpdateConstraints;
@property (nonatomic) UIImageView *fieldImageView;
@property (nonatomic) NSLayoutConstraint *fieldImageViewWidthConstraint;
@end

@implementation CBPTextFieldTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
}

- (void)updateConstraints
{
    if (!self.didUpdateConstraints) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[inputTextField]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"inputTextField": self.inputTextField}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fieldImageView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"fieldImageView": self.fieldImageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[fieldImageView]-[inputTextField]-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"inputTextField": self.inputTextField,
                                                                                           @"fieldImageView": self.fieldImageView}]];
        self.fieldImageViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.fieldImageView
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                                         multiplier:1.0f
                                                                           constant:0];
        [self.contentView addConstraint:self.fieldImageViewWidthConstraint];
        
        self.didUpdateConstraints = YES;
    }
    
    self.fieldImageViewWidthConstraint.constant = ([self.imageURI length]) ? 44.0f : 0;
    [super updateConstraints];
}

#pragma mark -
- (void)setImageURI:(NSString *)imageURI
{
    _imageURI = imageURI;
    
    [self.fieldImageView setImageWithURL:[NSURL URLWithString:imageURI]
                        placeholderImage:[UIImage imageNamed:@"default_avatar_image"]];
    
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

#pragma mark -
- (void)setInputTextField:(UITextField *)inputTextField
{
    _inputTextField = inputTextField;
    _inputTextField.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:_inputTextField];
    
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (UIImageView *)fieldImageView
{
    if (!_fieldImageView) {
        _fieldImageView = [UIImageView new];
        _fieldImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_fieldImageView];
    }
    
    return _fieldImageView;
}
@end
