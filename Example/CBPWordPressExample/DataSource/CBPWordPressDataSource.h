//
//  CBPWordPressDataSource.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPWordPressPost;

@interface CBPWordPressDataSource : NSObject <UITableViewDataSource>
@property (nonatomic, assign, readonly) NSInteger lastFetchedPostIndex;
@property (nonatomic, readonly) NSArray *posts;

- (void)addPost:(CBPWordPressPost *)post;
- (BOOL)canLoadMore;
- (void)loadMore:(BOOL)more withParams:(NSDictionary *)params withBlock:(void (^)(BOOL result, NSError *error))block;
- (CBPWordPressPost *)postAtIndex:(NSInteger)index;
- (void)replacePost:(CBPWordPressPost *)post;
- (void)updateWithBlock:(void (^)(BOOL result, NSError *error))block;
@end
