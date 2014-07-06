//
//  CBPHomeViewController.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 21/06/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPPostListViewController.h"

@interface CBPHomeViewController : CBPPostListViewController
- (void)backgroundUpdateWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
- (void)openURL:(NSURL *)url;
@end
