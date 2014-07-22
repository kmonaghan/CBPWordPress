//
//  CBPLargePostPreviewTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 14/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "SORelativeDateTransformer.h"

#import "UIImageView+AFNetworking.h"

#import "CBPLargePostPreviewTableViewCell.h"

@interface CBPLargePostPreviewTableViewCell()
@property (nonatomic, assign) BOOL constraintsUpdated;
@property (nonatomic) UILabel *postCommentLabel;
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
        
        //What madness is this? It turns out that we need to temporarily resize the content view as it starts off too small
        //See https://github.com/smileyborg/TableViewCellWithAutoLayout/blob/master/TableViewCellWithAutoLayout/TableViewController/RJTableViewCell.m#L77
        self.contentView.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CBPLargePostPreviewTableViewCellHeight);
        
        NSDictionary *views = @{@"postCommentLabel": self.postCommentLabel,
                                @"postDateLabel": self.postDateLabel,
                                @"postImageView": self.postImageView,
                                @"postTitleLabel": self.postTitleLabel};
        
        NSDictionary *metrics = @{@"padding": @(CBPPadding)};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[postTitleLabel]-(5)-[postImageView(150)]-(5)-[postDateLabel]-(5)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[postTitleLabel]-(padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[postImageView]-(padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding)-[postDateLabel]-(>=0)-[postCommentLabel]-(padding)-|"
                                                                                 options:0
                                                                                 metrics:metrics
                                                                                   views:views]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.postCommentLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.postDateLabel
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0f
                                                                      constant:0]];
        
        self.constraintsUpdated = YES;
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.postTitleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.frame) - (CBPPadding * 2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.postCommentLabel.text = nil;
    self.postDateLabel.text = nil;
    self.postImageView.image = nil;
    [self.postImageView cancelImageRequestOperation];
    self.postImageView.image = [UIImage imageNamed:@"post_default_image"];
    self.postTitleLabel.text = nil;
}

#pragma mark -
- (void)setCommentCount:(NSInteger)commentCount
{
    if (commentCount < 1) {
        self.postCommentLabel.text = NSLocalizedString(@"No comments yet", @"Text for when there are no comments on a post");
    } else if (commentCount == 1) {
        self.postCommentLabel.text = NSLocalizedString(@"1 comment", @"A single comment on this post");
    } else {
        self.postCommentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d comments", @"X comments on this post"), commentCount];
    }
}

- (void)setImageURI:(NSString *)imageURI
{
    [self.postImageView setImageWithURL:[NSURL URLWithString:imageURI]
                       placeholderImage:[UIImage imageNamed:@"post_default_image"]];
}

- (void)setPostDate:(NSDate *)postDate
{
    self.postDateLabel.text = [[SORelativeDateTransformer registeredTransformer] transformedValue:postDate];
    [self.postDateLabel sizeToFit];
}

- (void)setPostTitle:(NSString *)postTitle
{
    self.postTitleLabel.text = postTitle;
    [self.postTitleLabel sizeToFit];
}

- (UILabel *)postCommentLabel
{
    if (!_postCommentLabel) {
        _postCommentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _postCommentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        [self.contentView addSubview:_postCommentLabel];
    }
    
    return _postCommentLabel;
}

- (UILabel *)postDateLabel
{
    if (!_postDateLabel) {
        _postDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _postDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _postDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
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
        _postTitleLabel.numberOfLines = 0;
        _postTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        
        [self.contentView addSubview:_postTitleLabel];
    }
    
    return _postTitleLabel;
}
@end
