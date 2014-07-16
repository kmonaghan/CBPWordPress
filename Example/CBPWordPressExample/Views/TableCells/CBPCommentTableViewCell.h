//
//  CBPCommentTableViewCell.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 16/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CBPCommentTableViewCellHeight = 102.0;
static NSString * const CBPCommentTableViewCellIdentifier = @"CBPCommentTableViewCellIdentifier";

@protocol CBPCommentTableViewCellDelegate
- (void)openURL:(NSURL *)URL;
- (void)replyToComment:(NSInteger)commentId;
@end

@interface CBPCommentTableViewCell : UITableViewCell
@property (nonatomic) NSString *avatarURI;
@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSAttributedString *commentAttributedString;
@property (nonatomic) NSString *commentator;
@property (nonatomic) NSDate *commentDate;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, weak) id<CBPCommentTableViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger level;
@end
