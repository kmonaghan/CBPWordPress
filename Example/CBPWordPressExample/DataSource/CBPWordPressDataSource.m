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
@property (nonatomic) NSInteger page;
@end

@implementation CBPWordPressDataSource
- (void)loadMore:(BOOL)more withBlock:(void (^)(BOOL result, NSError *error))block
{
    __weak typeof(self) blockSelf = self;

    self.page = (more) ? self.page + 1 : 1;
    
    [NSURLSessionDataTask fetchPostsWithParams:@{@"page": [NSNumber numberWithInteger:self.page]}
                                      withBlock:^(CBPWordPressPostContainer *data, NSError *error) {
                                          
                                          if (!error) {
                                              NSMutableArray *posts = (blockSelf.posts && more) ? blockSelf.posts.mutableCopy : @[].mutableCopy;
                                              
                                              [posts addObjectsFromArray:data.posts];
                                              
                                              blockSelf.posts = posts;
                                              
                                              block(YES, nil);
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
