//
//  CBPLargePostPreviewTableViewCell.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 14/05/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat CBPLargePostPreviewTableViewCellHeight = 210.0;
static NSString * const CBPLargePostPreviewTableViewCellIdentifier = @"CBPLargePostPreviewTableViewCell";

@interface CBPLargePostPreviewTableViewCell : UITableViewCell
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic) NSString *imageURI;
@property (nonatomic) NSDate *postDate;
@property (nonatomic) NSString *postTitle;

@end
