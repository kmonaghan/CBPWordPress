//
//  CBPWordPressDataSource.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 31/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "NSString+HTML.h"

#import "CBPWordPressDataSource.h"

#import <CBPWordPress/CBPWordPress.h>

@interface CBPWordPressDataSource()

@end

@implementation CBPWordPressDataSource
- (void)loadWithBlock:(void (^)(BOOL result, NSError *error))block 
{
    __weak typeof(self) blockSelf = self;

    [NSURLSessionDataTask fetchPostsWithParams:nil
                                      withBlock:^(CBPWordPressPostContainer *data, NSError *error) {
                                          
                                          if (!error) {
                                              blockSelf.posts = data.posts;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CBPWordPressPostCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CBPWordPressPostCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CBPWordPressPost *post = self.posts[indexPath.row];
    
    cell.textLabel.text = [post.title kv_decodeHTMLCharacterEntities];
    cell.detailTextLabel.text = post.author.name;
    
    return cell;
}
@end
