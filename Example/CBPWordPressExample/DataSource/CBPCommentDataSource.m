//
//  CBPCommentDataSource.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 24/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSURLSessionDataTask+CBPWordPress.h"

#import "CBPCommentDataSource.h"

#import "CBPWordPressPost.h"
#import "CBPWordPressComment.h"

@interface CBPCommentDataSource()
@property (strong, nonatomic) CBPWordPressPost *post;
@end

@implementation CBPCommentDataSource
- (instancetype)initWithPost:(CBPWordPressPost *)post
{
    self = [super init];
    
    if (self) {
        _post = post;
    }
    
    return self;
}

- (void)loadWithBlock:(void (^)(BOOL result, NSError *error))block
{
    __weak typeof(self) blockSelf = self;
    
    [NSURLSessionDataTask fetchPostWithId:self.post.postId
                                withBlock:^(CBPWordPressPost *post, NSError *error){
                                    if (post) {
                                    blockSelf.post = post;
                                    
                                        block(YES, nil);
                                    } else {
                                        block(NO, error);
                                    }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.post.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBPWordPressPostCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CBPWordPressPostCell"];
    }
    
    CBPWordPressComment *comment = self.post.comments[indexPath.row];
    
    cell.textLabel.text = comment.name;
    cell.detailTextLabel.text = comment.content;
    
    return cell;
}
@end
