//
//  CBPPostListViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 29/03/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "CBPWordPress.h"

#import "NSString+HTML.h"

#import "CBPPostListViewController.h"
#import "CBPPostViewController.h"

#import "CBPLargePostPreviewTableViewCell.h"

@interface CBPPostListViewController ()
@property (nonatomic) NSNumber *authorId;
@property (nonatomic) NSNumber *categoryId;
@property (nonatomic) CBPLargePostPreviewTableViewCell *heightMeasuringCell;
@property (nonatomic) NSInteger postCount;
@property (nonatomic) NSNumber *tagId;
@end

@implementation CBPPostListViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.canInfiniteLoad = YES;
        self.canPullToRefresh = YES;
    }
    
    return self;
}

- (instancetype)initWithAuthorId:(NSNumber *)authorId
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _authorId = authorId;
    }
    
    return self;
}

- (instancetype)initWithCategoryId:(NSNumber *)categoryId
{
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        _categoryId = categoryId;
    }
    
    return self;
}

- (instancetype)initWithTagId:(NSNumber *)tagId
{
    self = [super initWithNibName:nil bundle:nil];
    
    if (self) {
        _tagId = tagId;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = [CBPWordPressDataSource new];
    
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = CBPLargePostPreviewTableViewCellHeight;
    self.tableView.estimatedRowHeight = CBPLargePostPreviewTableViewCellHeight;
    
    [self.tableView registerClass:[CBPLargePostPreviewTableViewCell class] forCellReuseIdentifier:CBPLargePostPreviewTableViewCellIdentifier];
    
    [self load:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.postCount < [self.dataSource.posts count]) {
        [self.tableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.postCount = [self.dataSource.posts count];
}

#pragma mark - 
- (NSDictionary *)generateParams
{
    NSMutableDictionary *params = @{}.mutableCopy;
    
    if (self.authorId) {
        params[CBPAuthorId] = self.authorId;
    }else if (self.categoryId) {
        params[CBPCategoryId] = self.categoryId;
    } else if (self.tagId) {
        params[CBPTagId] = self.tagId;
    }
    
    return params;
}

- (void)errorLoading:(NSError *)error wasLoadingMore:(BOOL)more
{
    if (!more) {
        [super errorLoading:error];
    }
    
    [self stopLoading:more];
}

- (void)load:(BOOL)more
{
    [super load:more];
    
    __weak typeof(self) weakSelf = self;
    
    [self.dataSource loadMore:more withParams:[self generateParams] withBlock:^(BOOL result, NSError *error){
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (result) {
            [strongSelf.tableView reloadData];
            
            strongSelf.canLoadMore = [strongSelf.dataSource canLoadMore];
            
            [strongSelf stopLoading:more];
        } else {
            [strongSelf errorLoading:error wasLoadingMore:more];
        }
    }];
}

#pragma mark - UITableViewDelegate
/**
 * Adapted from https://github.com/smileyborg/TableViewCellWithAutoLayout/blob/master/TableViewCellWithAutoLayout/TableViewController/RJTableViewController.m
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.heightMeasuringCell) {
        self.heightMeasuringCell = [CBPLargePostPreviewTableViewCell new];
    
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        [self.heightMeasuringCell setNeedsUpdateConstraints];
        [self.heightMeasuringCell updateConstraintsIfNeeded];
    }
    
    CBPWordPressPost *post = self.dataSource.posts[indexPath.row];
    
    self.heightMeasuringCell.postTitle = [post.title kv_decodeHTMLCharacterEntities];
    self.heightMeasuringCell.imageURI = post.thumbnail;
    self.heightMeasuringCell.postDate = post.date;
    self.heightMeasuringCell.commentCount = post.commentCount;
    
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
    
    if (height < CBPLargePostPreviewTableViewCellHeight) {
        height = CBPLargePostPreviewTableViewCellHeight;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPPostViewController *vc = [[CBPPostViewController alloc] initWithPost:self.dataSource.posts[indexPath.row]
                                                             withDataSource:self.dataSource
                                                                  withIndex:indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
