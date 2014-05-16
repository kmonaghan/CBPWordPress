//
//  CBPCommentTableViewCell.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 16/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CBPCommentTableViewCellHeight = 130.0;
static NSString * const CBPCommentTableViewCellIdentifier = @"CBPCommentTableViewCellIdentifier";

@interface CBPCommentTableViewCell : UITableViewCell
@property (nonatomic) NSString *avatarURI;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSString *commentator;
@property (nonatomic) NSDate *commentDate;

@end
