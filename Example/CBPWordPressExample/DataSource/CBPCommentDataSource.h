//
//  CBPCommentDataSource.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 24/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CBPCommentTableViewCell.h"

@class CBPWordPressPost;

@interface CBPCommentDataSource : NSObject <UITableViewDataSource>
@property (nonatomic, weak) id<CBPCommentTableViewCellDelegate> linkDelegate;

- (instancetype)initWithPost:(CBPWordPressPost *)post;
- (void)loadWithBlock:(void (^)(BOOL result, NSError *error))block;
@end
