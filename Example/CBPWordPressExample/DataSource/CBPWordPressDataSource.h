//
//  CBPWordPressDataSource.h
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPWordPressDataSource : NSObject <UITableViewDataSource>
@property (strong, nonatomic) NSArray *posts;

- (void)addPost:(CBPWordPressPost *)post;
- (void)loadMore:(BOOL)more withParams:(NSDictionary *)params withBlock:(void (^)(BOOL result, NSError *error))block;
- (void)updateWithBlock:(void (^)(BOOL result, NSError *error))block;
@end
