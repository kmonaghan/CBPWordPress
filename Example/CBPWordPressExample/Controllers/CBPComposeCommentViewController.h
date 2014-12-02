//
//  CBPComposeCommentViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CBPWordPress.h"

typedef void (^commentCompletionBlock)(CBPWordPressComment *comment, NSError *error);

@class CBPWordPressComment;

@interface CBPComposeCommentViewController : UITableViewController
- (instancetype)initWithPostId:(NSInteger)postId withCompletionBlock:(commentCompletionBlock)block;
- (instancetype)initWithPostId:(NSInteger)postId withComment:(CBPWordPressComment *)comment withCompletionBlock:(commentCompletionBlock)block;
@end
