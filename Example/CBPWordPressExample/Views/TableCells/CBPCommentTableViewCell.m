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

@interface CBPCommentTableViewCell()
@property (nonatomic) UIImageView *avatarImageView;
@property (nonatomic, assign) BOOL constraintsUpdated;
@property (nonatomic) UILabel *commentLabel;
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
                                @"commentLabel": self.commentLabel,
                                @"commentatorLabel": self.commentatorLabel,
                                @"commentDateLabel": self.commentDateLabel};
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[avatarImageView(40)]-(10)-[commentLabel(>=60)]-(10)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[commentatorLabel]-(>=0)-[commentDateLabel]-(10)-[commentLabel]-(10)-|"
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
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[commentLabel]-(%f)-|", CBPCommentTableViewCellPadding, CBPCommentTableViewCellPadding]
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
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    self.commentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.frame) - (CBPCommentTableViewCellPadding * 2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.avatarImageView.image = nil;
    [self.avatarImageView cancelImageRequestOperation];
    self.avatarImageView.image = [UIImage imageNamed:@"default_avatar_image"];
    self.commentLabel.text = nil;
    self.commentatorLabel.text = nil;
    self.commentDateLabel.text = nil;
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
    
    self.commentLabel.attributedText = attributedComment;
    
    if (error) {
        NSLog(@"error turning comment into attrinuted string: %@", error);
    }
    
    [self.commentLabel sizeToFit];
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

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [UILabel new];
        _commentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _commentLabel.numberOfLines = 0;
        _commentLabel.adjustsFontSizeToFitWidth = NO;
        
        [self.contentView addSubview:_commentLabel];
    }
    
    return _commentLabel;
}

- (UILabel *)commentatorLabel
{
    if (!_commentatorLabel) {
        _commentatorLabel = [UILabel new];
        _commentatorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_commentatorLabel];
    }
    
    return _commentatorLabel;
}

- (UILabel *)commentDateLabel
{
    if (!_commentDateLabel) {
        _commentDateLabel = [UILabel new];
        _commentDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_commentDateLabel];
    }
    
    return _commentDateLabel;
}
@end
