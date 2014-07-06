//
//  CBPPostViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 22/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBPWordPressPost;
@class CBPWordPressDataSource;

@interface CBPPostViewController : UIViewController
- (id)initWithPost:(CBPWordPressPost *)post;
- (id)initWithPost:(CBPWordPressPost *)post withDataSource:(CBPWordPressDataSource *)dataSource withIndex:(NSInteger)index;
- (instancetype)initWithURL:(NSURL *)url;
@end
