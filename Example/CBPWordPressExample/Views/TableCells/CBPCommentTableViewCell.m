//
//  CBPCommentTableViewCell.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 16/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "CBPCommentTableViewCell.h"

static const CGFloat CBPCommentTableViewCellPadding = 15.0;

@interface CBPCommentTableViewCell() <UITextViewDelegate>
@property (nonatomic) UIImageView *avatarImageView;
@property (nonatomic, assign) BOOL constraintsUpdated;
@property (nonatomic) UITextView *commentTextView;
@property (nonatomic) UILabel *commentatorLabel;
@property (nonatomic) UILabel *commentDateLabel;
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
        
        NSDictionary *views = @{@"avatarImageView": self.avatarImageView,
                                @"commentTextView": self.commentTextView,
                                @"commentatorLabel": self.commentatorLabel,
                                @"commentDateLabel": self.commentDateLabel};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[avatarImageView(40)]-(10)-[commentTextView]-(%f)-|", CBPCommentTableViewCellPadding, CBPCommentTableViewCellPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[commentatorLabel]-(>=0)-[commentDateLabel]", CBPCommentTableViewCellPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[avatarImageView(40)]-(%f)-[commentatorLabel]-(%f)-|", CBPCommentTableViewCellPadding, CBPCommentTableViewCellPadding, CBPCommentTableViewCellPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[avatarImageView]-(%f)-[commentDateLabel]-(%f)-|", CBPCommentTableViewCellPadding, CBPCommentTableViewCellPadding, CBPCommentTableViewCellPadding]
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[commentTextView]-(%f)-|", CBPCommentTableViewCellPadding, CBPCommentTableViewCellPadding]
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
    
    [self.commentTextView sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.avatarImageView cancelImageRequestOperation];
    self.avatarImageView.image = [UIImage imageNamed:@"default_avatar_image"];
    self.commentTextView.text = nil;
    self.commentatorLabel.text = nil;
    self.commentDateLabel.text = nil;
    
    [self setNeedsUpdateConstraints];
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
    
    NSMutableAttributedString *attributedComment = [[NSAttributedString alloc] initWithData:[comment dataUsingEncoding:NSUTF8StringEncoding]
                                                                                    options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                         documentAttributes:nil
                                                                                      error:&error].mutableCopy;
    [attributedComment addAttribute:NSFontAttributeName value:[UIFont preferredFontForTextStyle:UIFontTextStyleBody] range:NSMakeRange(0, attributedComment.length)];
    
    self.commentTextView.attributedText = attributedComment;
    
    if (error) {
        NSLog(@"error turning comment into attributed string: %@", error);
    }

    [self setNeedsUpdateConstraints];
}

- (void)setCommentator:(NSString *)commentator
{
    self.commentatorLabel.text = commentator;
    [self.commentatorLabel sizeToFit];
}

- (void)setCommentDate:(NSDate *)commentDate
{
    self.commentDateLabel.text = [commentDate description];
    [self.commentDateLabel sizeToFit];
}

- (UIImageView *)avatarImageView
{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_avatar_image"]];
        _avatarImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_avatarImageView];
    }
    
    return _avatarImageView;
}

- (UITextView *)commentTextView
{
    if (!_commentTextView) {
        _commentTextView = [UITextView new];
        _commentTextView.translatesAutoresizingMaskIntoConstraints = NO;
        _commentTextView.editable = NO;
        _commentTextView.scrollEnabled = NO;
        _commentTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _commentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
        _commentTextView.delegate = self;
        
        _commentTextView.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:_commentTextView];
    }
    
    return _commentTextView;
}

- (UILabel *)commentatorLabel
{
    if (!_commentatorLabel) {
        _commentatorLabel = [UILabel new];
        _commentatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _commentatorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
        [self.contentView addSubview:_commentatorLabel];
    }
    
    return _commentatorLabel;
}

- (UILabel *)commentDateLabel
{
    if (!_commentDateLabel) {
        _commentDateLabel = [UILabel new];
        _commentDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _commentDateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        
        [self.contentView addSubview:_commentDateLabel];
    }
    
    return _commentDateLabel;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [self.delegate openURL:URL];
    
    return NO;
}

#pragma mark - 
- (CGFloat)cellHeight
{
    return CGRectGetMaxY(self.commentTextView.frame) + CBPCommentTableViewCellPadding;
}

@end
