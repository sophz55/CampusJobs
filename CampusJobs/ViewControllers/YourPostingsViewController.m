//
//  YourPostingsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "YourPostingsViewController.h"
#import "PostDetailsViewController.h"
#import "SegueConstants.h"
#import "Colors.h"
#import "Format.h"
#import <ChameleonFramework/Chameleon.h>

@interface YourPostingsViewController () <UITableViewDelegate, UITableViewDataSource, PostDetailsDelegate>
@property (weak, nonatomic) IBOutlet UITableView *previousPostTableView;
@property (strong, nonatomic) NSArray * previousPostsArray;
@property (weak, nonatomic) IBOutlet UIView *noPostingsView;
@property (weak, nonatomic) IBOutlet UILabel *noPostingsLabel;
@property (assign, nonatomic) CGFloat frameOriginY;

@end

@implementation YourPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previousPostTableView.delegate=self;
    self.previousPostTableView.dataSource=self;
    self.previousPostsArray=[[NSArray alloc]init];
    [self fetchUserPosts];
    [self addRefreshControl];
    [self displayBackgroundColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.noPostingsView.frame = self.view.frame;
    [Format configurePlaceholderView:self.noPostingsView withLabel:self.noPostingsLabel];
    self.noPostingsLabel.text = @"LOADING YOUR POSTINGS...";
    
    self.previousPostTableView.frame = self.view.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of/Users/szheng/Desktop/CampusJobs/CampusJobs/Models/Post.h any resources that can be recreated.
}

- (void)reloadData {
    [self fetchUserPosts];
}

- (void)fetchUserPosts{
    PFQuery *query=[PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"taker"];
    [query includeKey:@"username"];
    [query includeKey:@"completedDate"];
    [query includeKey: @"title"];
    [query includeKey: @"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * previousPosts, NSError * error){
        if(previousPosts!=nil){
            if (previousPosts.count > 0) {
                self.noPostingsView.hidden = YES;
            } else {
                self.noPostingsView.hidden = NO;
                self.noPostingsLabel.text = @"You have no postings. Click the compose button above to get started!";
                [self.noPostingsLabel setTextAlignment:NSTextAlignmentLeft];
            }
            
            self.previousPostsArray=previousPosts;
            [self.previousPostTableView reloadData];
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PreviousUserPostCell * previousUserPostCell=[tableView dequeueReusableCellWithIdentifier:@"PreviousUserPostCell" forIndexPath:indexPath];
    Post * post=self.previousPostsArray[indexPath.row];
    previousUserPostCell.previousPost=post;
    [previousUserPostCell setPreviousPost:post];
    return previousUserPostCell;
}

//Visual formatting for each cell
//Creates spaces in between the cells, creates round corners, adds cell shadow and cell color
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.previousPostTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.layer.backgroundColor=[[UIColor clearColor]CGColor];
    //initializes white rounded cell
    UIView  *roundedCellView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-10, 70)];
    CGFloat colors[]={1.0, 1.0, 1.0, 1.0};
    roundedCellView.layer.backgroundColor=CGColorCreate(CGColorSpaceCreateDeviceRGB(), colors);
    roundedCellView.layer.masksToBounds=false;
    //border color
    roundedCellView.layer.borderWidth=0.3;
    roundedCellView.layer.borderColor=[[Colors primaryBlueColor]CGColor];
    //rounded edges
    roundedCellView.layer.cornerRadius=3.0;
    //adds shadow property
    roundedCellView.layer.shadowOffset=CGSizeMake(0, 0);
    roundedCellView.layer.shadowOpacity=0.3;
    roundedCellView.layer.shadowRadius=1.0;
    roundedCellView.clipsToBounds = false;
    roundedCellView.layer.shadowColor=[[UIColor blackColor]CGColor];
    //adds rounded cell to each cell content view
    [cell.contentView addSubview:roundedCellView];
    [cell.contentView sendSubviewToBack:roundedCellView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.previousPostsArray.count;
}

- (void)addRefreshControl{
    UIRefreshControl * refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.previousPostTableView insertSubview:refreshControl atIndex:0];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl{
    //fetch all of the nearby posts
    [self fetchUserPosts];
    //tell the refresh control to stop spinning
    [refreshControl endRefreshing];
}

//Adds background color
- (void)displayBackgroundColor{
    self.view.backgroundColor=[Colors secondaryGreyLighterColor];
    self.previousPostTableView.backgroundColor=[Colors secondaryGreyLighterColor];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:yourPostingsToPostDetailsSegue]) {
        PreviousUserPostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.previousPostTableView indexPathForCell:tappedCell];
        [self.previousPostTableView deselectRowAtIndexPath:indexPath animated:YES];
        Post *post = self.previousPostsArray[indexPath.row];
        PostDetailsViewController *postDetailsController = [segue destinationViewController];
        postDetailsController.delegate = self;
        postDetailsController.post = post;
    }
}

@end
