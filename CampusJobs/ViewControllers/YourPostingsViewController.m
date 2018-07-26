//
//  YourPostingsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "YourPostingsViewController.h"
#import "PostDetailsViewController.h"

@interface YourPostingsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *previousPostTableView;
@property (strong, nonatomic) NSArray * previousPostsArray;

@end

@implementation YourPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.previousPostTableView.delegate=self;
    self.previousPostTableView.dataSource=self;
    self.previousPostsArray=[[NSArray alloc]init];
    [self fetchPreviousUserPosts];
    UIRefreshControl * refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.previousPostTableView insertSubview:refreshControl atIndex:0];
    self.previousPostTableView.rowHeight=75;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of/Users/szheng/Desktop/CampusJobs/CampusJobs/Models/Post.h any resources that can be recreated.
}


-(void)fetchPreviousUserPosts{
    PFQuery * query=[PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"taker"];
    [query includeKey:@"username"];
    [query includeKey:@"completedDate"];
    [query includeKey: @"title"];
    [query includeKey: @"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * previousPosts, NSError * error){
        if(previousPosts!=nil){
            self.previousPostsArray=previousPosts;
            [self.previousPostTableView reloadData];
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapComposeButton:(id)sender {
     [self performSegueWithIdentifier:@"composeNewPostSegue" sender:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PreviousUserPostCell * previousUserPostCell=[tableView dequeueReusableCellWithIdentifier:@"PreviousUserPostCell" forIndexPath:indexPath];
    Post * post=self.previousPostsArray[indexPath.row];
    previousUserPostCell.previousPost=post;
    [previousUserPostCell setPreviousPost:post];
    return previousUserPostCell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.previousPostsArray.count;
}

-(void)beginRefresh:(UIRefreshControl *)refreshControl{
    //fetch all of the nearby posts
    [self fetchPreviousUserPosts];
    //tell the refresh control to stop spinning
    [refreshControl endRefreshing];
}


#pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"yourPostingsToDetailSegue"]) {
        PreviousUserPostCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.previousPostTableView indexPathForCell:tappedCell];
        Post *post = self.previousPostsArray[indexPath.row];
        PostDetailsViewController *postDetailsController = [segue destinationViewController];
        postDetailsController.post = post;
    }
}




@end
