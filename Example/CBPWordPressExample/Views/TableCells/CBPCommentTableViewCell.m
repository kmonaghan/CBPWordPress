//
//  CBPCommentTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 16/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "TTTAttributedLabel.h"
#import "UIImageView+AFNetworking.h"

#import "CBPCommentTableViewCell.h"

static const CGFloat CBPCommentTableViewCellAvatarHeight = 40.0;
static NSDateFormatter *commentDateFormatter = nil;

@interface CBPCommentTableViewCell() <TTTAttributedLabelDelegate>
@property (nonatomic) UIImageView *avatarImageView;
@property (nonatomic, assign) BOOL constraintsUpdated;
@property (nonatomic) UIView *commentHeaderView;
@property (nonatomic) TTTAttributedLabel *commentLabel;
@property (nonatomic) UILabel *commentatorLabel;
@property (nonatomic) UILabel *commentDateLabel;
@property (nonatomic) UIButton *replyButton;
@end

@implementation CBPCommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.constraintsUpdated) {
        
        //What madness is this? It turns out that we need to temporarily resize the content view as it starts off too small
        //See https://github.com/smileyborg/TableViewCellWithAutoLayout/blob/master/TableViewCellWithAutoLayout/TableViewController/RJTableViewCell.m#L77
        self.contentView.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), CBPCommentTableViewCellHeight);
        
        NSDictionary *views = @{@"commentHeaderView": self.commentHeaderView,
                                @"commentLabel": self.commentLabel};
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[commentHeaderView][commentLabel]-(%f)-|", CBPPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-(%f)-[commentHeaderView]-(%f)-|", CBPPadding, CBPPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"|-(%f)-[commentLabel]-(%f)-|", CBPPadding, CBPPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];

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
    
    self.commentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.frame) - (CBPPadding * 2);
    self.commentatorLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentHeaderView.frame) - CBPCommentTableViewCellAvatarHeight - CBPPadding - CGRectGetWidth(self.replyButton.frame);
    self.commentDateLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.commentHeaderView.frame) - CBPCommentTableViewCellAvatarHeight - CBPPadding - CGRectGetWidth(self.replyButton.frame);
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.avatarImageView cancelImageRequestOperation];
    self.avatarImageView.image = [UIImage imageNamed:@"default_avatar_image"];
    self.commentLabel.text = nil;
    self.commentatorLabel.text = nil;
    self.commentDateLabel.text = nil;
}

#pragma mark -
- (void)replyAction
{
    [self.delegate replyToComment:self.commentId];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [self.delegate openURL:url];
}

#pragma mark -
- (void)setAvatarURI:(NSString *)avatarURI
{
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:avatarURI]
                         placeholderImage:[UIImage imageNamed:@"default_avatar_image"]];
}

- (void)setComment:(NSString *)comment
{
    NSError *error;
    
    NSMutableAttributedString *attributedComment = [[NSAttributedString alloc] initWithData:[comment dataUsingEncoding:NSISOLatin1StringEncoding]
                                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                         documentAttributes:nil
                                                                                      error:&error].mutableCopy;
    [attributedComment addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] range:NSMakeRange(0, attributedComment.length)];
    
    [self.commentLabel setText:attributedComment];
    
    [self.commentLabel sizeToFit];
}

- (void)setCommentAttributedString:(NSAttributedString *)commentAttributedString
{
    NSMutableAttributedString *attributedComment = commentAttributedString.mutableCopy;
    [attributedComment addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] range:NSMakeRange(0, attributedComment.length)];
    
    _commentAttributedString = attributedComment;
    
    [self.commentLabel setText:attributedComment];
    
    [self.commentLabel sizeToFit];
}

- (void)setCommentator:(NSString *)commentator
{
    self.commentatorLabel.text = commentator;
    [self.commentatorLabel sizeToFit];
}

- (void)setCommentDate:(NSDate *)commentDate
{
    if (!commentDateFormatter) {
        commentDateFormatter = [NSDateFormatter new];
        [commentDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    self.commentDateLabel.text = [commentDateFormatter stringFromDate:commentDate];
    [self.commentDateLabel sizeToFit];
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_avatar_image"]];
        _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _avatarImageView;
}

- (UILabel *)commentatorLabel
{
    if (!_commentatorLabel) {
        _commentatorLabel = [UILabel new];
        _commentatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _commentatorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    
    return _commentatorLabel;
}

- (UILabel *)commentDateLabel
{
    if (!_commentDateLabel) {
        _commentDateLabel = [UILabel new];
        _commentDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _commentDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }
    
    return _commentDateLabel;
}

- (UIView *)commentHeaderView
{
    if (!_commentHeaderView) {
        _commentHeaderView = [UIView new];
        _commentHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [_commentHeaderView addSubview:self.avatarImageView];
        [_commentHeaderView addSubview:self.commentatorLabel];
        [_commentHeaderView addSubview:self.commentDateLabel];
        [_commentHeaderView addSubview:self.replyButton];
        
        NSDictionary *views = @{@"avatarImageView": self.avatarImageView,
                                @"commentatorLabel": self.commentatorLabel,
                                @"commentDateLabel": self.commentDateLabel,
                                @"replyButton": self.replyButton};
        
        [_commentHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[commentatorLabel]-(>=0)-[commentDateLabel]-(%f)-|", CBPPadding, CBPPadding]
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:views]];
        [_commentHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[replyButton]"
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:views]];
        [_commentHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"[avatarImageView(%f)]", CBPCommentTableViewCellAvatarHeight]
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:views]];
        [_commentHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[avatarImageView(%f)]-(%f)-[commentatorLabel]-(>=0)-[replyButton]|", CBPCommentTableViewCellAvatarHeight, CBPPadding]
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:views]];
        [_commentHeaderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|[avatarImageView(%f)]-(%f)-[commentDateLabel]-(>=0)-[replyButton]|", CBPCommentTableViewCellAvatarHeight, CBPPadding]
                                                                                   options:0
                                                                                   metrics:nil
                                                                                     views:views]];
        [_commentHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:self.avatarImageView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_commentHeaderView
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1.0f
                                                                        constant:0]];
        
        [self.contentView addSubview:_commentHeaderView];
        
        
    }
    
    return _commentHeaderView;
}

- (TTTAttributedLabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [TTTAttributedLabel new];
        _commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _commentLabel.numberOfLines = 0;
        _commentLabel.delegate = self;
        _commentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;

        [self.contentView addSubview:_commentLabel];
    }
    
    return _commentLabel;
}

- (UIButton *)replyButton
{
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_replyButton setTitle:NSLocalizedString(@"Reply", nil) forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_replyButton addTarget:self action:@selector(replyAction) forControlEvents:UIControlEventTouchUpInside];
        [_replyButton sizeToFit];
    }
    
    return _replyButton;
}

@end
