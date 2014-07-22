//
//  CBPWordPressDataSource.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSString+HTML.h"

#import "CBPWordPressDataSource.h"

#import "CBPLargePostPreviewTableViewCell.h"

@interface CBPWordPressDataSource()
@property (nonatomic, assign, readwrite) NSInteger lastFetchedPostIndex;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSMutableDictionary *postIdList;
@property (nonatomic, readwrite) NSArray *posts;
@end

@implementation CBPWordPressDataSource
- (void)replacePost:(CBPWordPressPost *)post
{
    NSMutableArray *posts = self.posts.mutableCopy;

    NSIndexSet *hits = [self.posts indexesOfObjectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(CBPWordPressPost *currentPost, NSUInteger idx, BOOL *stop) {
        if (currentPost.postId == post.postId) {
            
            *stop = YES;
            
            return YES;
        }
        return NO;
    }];
    
    NSInteger index = [hits firstIndex];
    
    if (index != NSNotFound) {
        [posts replaceObjectAtIndex:index withObject:post];
    }
    
    self.posts = posts;
}

- (void)addPost:(CBPWordPressPost *)post
{
    if (!self.posts) {
        self.posts = @[];
    }
    
    NSMutableArray *posts = self.posts.mutableCopy;
    [posts addObject:post];
    
    if (!self.postIdList) {
        self.postIdList = @{}.mutableCopy;
    }
    
    self.postIdList[@(post.postId)] = @(post.postId);
    self.posts = posts;
}

- (void)loadMore:(BOOL)more withParams:(NSDictionary *)params withBlock:(void (^)(BOOL result, NSError *error))block
{
    __weak typeof(self) weakSelf = self;
    
    if (more) {
        self.page++;
    } else {
        self.page = 1;
        self.postIdList = @{}.mutableCopy;
        self.lastFetchedPostIndex = 0;
    }
    
    NSMutableDictionary *postParams = (params) ? params.mutableCopy : @{}.mutableCopy;
    
    postParams[@"page"] = @(self.page);
    
    [NSURLSessionDataTask fetchPostsWithParams:postParams
                                     withBlock:^(CBPWordPressPostsContainer *data, NSError *error) {
                                         if (!error) {
                                             __strong typeof(weakSelf) strongSelf = weakSelf;

                                             NSMutableArray *posts = (strongSelf.posts && more) ? strongSelf.posts.mutableCopy : @[].mutableCopy;
                                             
                                             for (CBPWordPressPost *post in data.posts) {
                                                 if (strongSelf.postIdList[@(post.postId)] && posts[[strongSelf.postIdList[@(post.postId)] integerValue]]) {
                                                     [posts replaceObjectAtIndex:[strongSelf.postIdList[@(post.postId)] integerValue] withObject:post];
                                                 } else {
                                                     [posts addObject:post];
                                                     
                                                     strongSelf.postIdList[@(post.postId)] = @([posts count] - 1);
                                                 }
                                             }
                                             
                                             strongSelf.posts = posts;
                                             
                                             block(YES, nil);
                                         } else {
                                             NSLog(@"Error: %@", error);
                                             block(NO, error);
                                         }
                                     }];
}

- (CBPWordPressPost *)postAtIndex:(NSInteger)index
{
    if (index >= [self.posts count]) {
        return nil;
    }
    
    self.lastFetchedPostIndex = index;
    return self.posts[index];
}

- (void)updateWithBlock:(void (^)(BOOL result, NSError *error))block
{
    __weak typeof(self) weakSelf = self;
    
    [NSURLSessionDataTask fetchPostsWithParams:nil
                                     withBlock:^(CBPWordPressPostsContainer *data, NSError *error) {
                                         if (!error) {
                                             __strong typeof(weakSelf) strongSelf = weakSelf;
                                             
                                             NSMutableArray *posts = (strongSelf.posts) ? strongSelf.posts.mutableCopy : @[].mutableCopy;
                                             NSMutableArray *newPosts = @[].mutableCopy;
                                             
                                             for (CBPWordPressPost *post in data.posts) {
                                                 
                                                 if (!strongSelf.postIdList[@(post.postId)]) {
                                                     [newPosts addObject:post];
                                                 } else {
                                                     [posts replaceObjectAtIndex:[strongSelf.postIdList[@(post.postId)] integerValue] withObject:post];
                                                 }
                                             }
                                             
                                             strongSelf.posts = [newPosts arrayByAddingObjectsFromArray:posts];
                                             
                                             NSMutableDictionary *postIdList = @{}.mutableCopy;
                                             
                                             NSInteger index = 0;
                                             for (CBPWordPressPost *post in strongSelf.posts)
                                             {
                                                 postIdList[@(post.postId)] = @(index);
                                                 index++;
                                             }
                                             
                                             strongSelf.postIdList = postIdList;

                                             block([posts count], nil);
                                         } else {
                                             NSLog(@"Error: %@", error);
                                             block(NO, error);
                                         }
                                     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPLargePostPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CBPLargePostPreviewTableViewCellIdentifier];
    
    CBPWordPressPost *post = self.posts[indexPath.row];
    
    cell.postTitle = [post.title kv_decodeHTMLCharacterEntities];
    cell.imageURI = post.thumbnail;
    cell.postDate = post.date;
    cell.commentCount = post.commentCount;
    
    return cell;
}
@end
