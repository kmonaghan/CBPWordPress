//
//  CBPCommentsViewController.m
//  CBPWordPressExample
//
//  Created by Karl Monaghan on 23/04/2014.
//  Copyright (c) 2014 Crayons and Brown Paper. All rights reserved.
//

#import "TOWebViewController.h"

#import "CBPCommentsViewController.h"
#import "CBPComposeCommentViewController.h"

#import "CBPCommentDataSource.h"

#import "CBPCommentTableViewCell.h"

@interface CBPCommentsViewController () <CBPCommentTableViewCellDelegate, UITableViewDelegate>
@property (nonatomic) CBPCommentDataSource *dataSource;
@property (nonatomic) CBPCommentTableViewCell *heightMeasuringCell;
@property (nonatomic) CBPWordPressPost *post;
@property (nonatomic) UITableView *tableView;
@end

@implementation CBPCommentsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPost:(CBPWordPressPost *)post
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self) {
        _post = post;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[CBPCommentDataSource alloc] initWithPost:self.post];
    self.dataSource.linkDelegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = CBPCommentTableViewCellHeight;
    self.tableView.estimatedRowHeight = CBPCommentTableViewCellHeight;
    
    [self.tableView registerClass:[CBPCommentTableViewCell class] forCellReuseIdentifier:CBPCommentTableViewCellIdentifier];
    
    if ([self.post.commentStatus isEqualToString:@"open"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                               target:self
                                                                                               action:@selector(composeCommentAction)];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions
- (void)composeCommentAction
{
    __weak typeof(self) blockSelf = self;
    
    CBPComposeCommentViewController *vc = [[CBPComposeCommentViewController alloc] initWithPostId:self.post.postId
                                                                              withCompletionBlock:^(CBPWordPressComment *comment, NSError *error) {
                                                                                  [blockSelf.navigationController dismissViewControllerAnimated:YES
                                                                                                                                     completion:^() {
                                                                                                                                         
                                                                                                                                         if (error) {
                                                                                                                                             
                                                                                                                                         } else if (comment) {
                                                                                                                                             
                                                                                                                                         }}];
                                                                              }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark -
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    }
    
    return _tableView;
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
    self.heightMeasuringCell.comment = comment.content;

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
    //CGFloat height = [self.heightMeasuringCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat height = self.heightMeasuringCell.cellHeight;

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
@end
