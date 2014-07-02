//
//  CBPComposeCommentViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^commentCompletionBlock)(CBPWordPressComment *comment, NSError *error);

@interface CBPComposeCommentViewController : UITableViewController
- (instancetype)initWithPostId:(NSInteger)postId withCompletionBlock:(commentCompletionBlock)block;
- (instancetype)initWithPostId:(NSInteger)postId withCommentId:(NSInteger)commentId withCompletionBlock:(commentCompletionBlock)block;
@end
