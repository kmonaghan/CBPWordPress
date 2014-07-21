//
//  CBPCommentsViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import <SVPullToRefresh/SVPullToRefresh.h>
#import "TOWebViewController.h"

#import "CBPCommentsViewController.h"
#import "CBPComposeCommentViewController.h"

#import "CBPCommentDataSource.h"

#import "CBPCommentTableViewCell.h"

@interface CBPCommentsViewController () <CBPCommentTableViewCellDelegate>
@property (nonatomic) CBPCommentDataSource *dataSource;
@property (nonatomic) CBPCommentTableViewCell *heightMeasuringCell;
@property (nonatomic) CBPWordPressPost *post;
@property (nonatomic) UITableView *tableView;
@end

@implementation CBPCommentsViewController
- (instancetype)initWithPost:(CBPWordPressPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self) {
        self.canPullToRefresh = YES;
        
        _post = post;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[CBPCommentDataSource alloc] initWithPost:self.post];
    self.dataSource.linkDelegate = self;
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = CBPCommentTableViewCellHeight;
    self.tableView.estimatedRowHeight = CBPCommentTableViewCellHeight;
    
    [self.tableView registerClass:[CBPCommentTableViewCell class] forCellReuseIdentifier:CBPCommentTableViewCellIdentifier];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f)];
    header.backgroundColor = [UIColor lightGrayColor];
    
    self.tableView.tableHeaderView = header;
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f)];
    
    self.tableView.tableFooterView = footer;
    
    if ([self.post.commentStatus isEqualToString:@"open"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                               target:self
                                                                                               action:@selector(composeCommentAction)];
    }
}

#pragma mark - Button Actions
- (void)composeCommentAction
{
    [self replyToComment:0];
}

- (void)load:(BOOL)more
{
    __weak typeof(self) weakSelf = self;
    [self.dataSource loadWithBlock:^(BOOL result, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf stopLoading:more];
        
        if (error) {
            return;
        }
        
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate
/**
 * Adapted from https://github.com/smileyborg/TableViewCellWithAutoLayout/blob/master/TableViewCellWithAutoLayout/TableViewController/RJTableViewController.m
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.heightMeasuringCell) {
        self.heightMeasuringCell = [CBPCommentTableViewCell new];
        
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        [self.heightMeasuringCell setNeedsUpdateConstraints];
        [self.heightMeasuringCell updateConstraintsIfNeeded];
    }
    
    CBPWordPressComment *comment = self.post.comments[indexPath.row];
    
    self.heightMeasuringCell.commentator = comment.name;
    self.heightMeasuringCell.commentDate = comment.date;
    self.heightMeasuringCell.commentAttributedString = comment.contentAttributedString;
    self.heightMeasuringCell.level = comment.level;
    
    // The cell's width must be set to the same size it will end up at once it is in the table view.
    // This is important so that we'll get the correct height for different table view widths, since our cell's
    // height depends on its width due to the multi-line UILabel word wrapping. Don't need to do this above in
    // -[tableView:cellForRowAtIndexPath:] because it happens automatically when the cell is used in the table view.
    self.heightMeasuringCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(self.heightMeasuringCell.bounds));
    
    // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints
    // (Note that the preferredMaxLayoutWidth is set on multi-line UILabels inside the -[layoutSubviews] method
    // in the UITableViewCell subclass
    [self.heightMeasuringCell setNeedsLayout];
    [self.heightMeasuringCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    CGFloat height = [self.heightMeasuringCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    // Add an extra point to the height to account for the cell separator, which is added between the bottom
    // of the cell's contentView and the bottom of the table view cell.
    height += 1;
    
    return height;
}

#pragma mark - CBPCommentTableViewCellDelegate
- (void)openURL:(NSURL *)URL
{
    TOWebViewController *webBrowser = [[TOWebViewController alloc] initWithURL:URL];
    [self.navigationController pushViewController:webBrowser animated:YES];
}

- (void)replyToComment:(NSInteger)commentId
{
    CBPWordPressComment *replyComment = nil;
    NSInteger commentIndex = self.post.commentCount;
    
    if (commentId) {
        NSArray *comments = [self.post.comments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"commentId == %d", commentId]];
    
        replyComment = [comments firstObject];
        
        if (replyComment) {
            commentIndex = [self.post.comments indexOfObject:replyComment] + 1;
        }
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    commentCompletionBlock block = ^(CBPWordPressComment *comment, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (comment) {
            [strongSelf.post insertComment:comment atIndex:commentIndex];
            
            [strongSelf.tableView beginUpdates];
            
            [strongSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:commentIndex
                                                                              inSection:0]]
                                        withRowAnimation:UITableViewRowAnimationFade];
            
            [strongSelf.tableView endUpdates];
            
            [strongSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:commentIndex
                                                                            inSection:0]
                                        atScrollPosition:UITableViewScrollPositionTop
                                                animated:YES];
        }
        
        [weakSelf.navigationController dismissViewControllerAnimated:YES
                                                          completion:^() {
                                                              if (comment) {
                                                                  [strongSelf showMessage:NSLocalizedString(@"Comment submitted", nil)];
                                                              }
                                                          }];
    };
    
    CBPComposeCommentViewController *vc = [[CBPComposeCommentViewController alloc] initWithPostId:self.post.postId
                                                                                      withComment:replyComment
                                                                              withCompletionBlock:block];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navController animated:YES completion:nil];
}
@end
