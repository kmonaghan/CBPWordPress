//
//  CBPLargePostPreviewTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 14/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "CBPLargePostPreviewTableViewCell.h"

static const CGFloat CBPLargePostPreviewTableViewCellPadding = 15.0;

@interface CBPLargePostPreviewTableViewCell()
@property (nonatomic, assign) BOOL constraintsUpdated;
@property (nonatomic) UILabel *postDateLabel;
@property (nonatomic) UIImageView *postImageView;
@property (nonatomic) UILabel *postTitleLabel;
@end

@implementation CBPLargePostPreviewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.constraintsUpdated) {
        NSDictionary *views = @{@"postDateLabel": self.postDateLabel,
                                @"postImageView": self.postImageView,
                                @"postTitleLabel": self.postTitleLabel};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[postTitleLabel][postImageView(150)][postDateLabel]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[postTitleLabel]-(%f)-|", CBPLargePostPreviewTableViewCellPadding, CBPLargePostPreviewTableViewCellPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[postImageView]-(%f)-|", CBPLargePostPreviewTableViewCellPadding, CBPLargePostPreviewTableViewCellPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[postDateLabel]", CBPLargePostPreviewTableViewCellPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        self.constraintsUpdated = YES;
    }
    
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    [self.postImageView cancelImageRequestOperation];
    
    self.postImageView.image = nil;
    self.postTitleLabel.text = nil;
}

#pragma mark -
- (void)setImageURI:(NSString *)imageURI
{
    NSLog(@"imageURI: %@", imageURI);
    
    [self.postImageView setImageWithURL:[NSURL URLWithString:imageURI]
                       placeholderImage:[UIImage imageNamed:@"post_default_image"]];
}

- (void)setPostDate:(NSDate *)postDate
{
    self.postDateLabel.text = [postDate description];
    [self.postDateLabel sizeToFit];
}

- (void)setPostTitle:(NSString *)postTitle
{
    self.postTitleLabel.text = postTitle;
    [self.postTitleLabel sizeToFit];
}

- (UILabel *)postDateLabel
{
    if (!_postDateLabel) {
        _postDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_postDateLabel];
    }
    
    return _postDateLabel;
}

- (UIImageView *)postImageView
{
    if (!_postImageView) {
        _postImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"post_default_image"]];
        _postImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _postImageView.contentMode = UIViewContentModeScaleAspectFill;
        _postImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:_postImageView];
    }
    
    return _postImageView;
}

- (UILabel *)postTitleLabel
{
    if (!_postTitleLabel) {
        _postTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _postTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - (CBPLargePostPreviewTableViewCellPadding * 2);
        
        [self.contentView addSubview:_postTitleLabel];
    }
    
    return _postTitleLabel;
}
@end
