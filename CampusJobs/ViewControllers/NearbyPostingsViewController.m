//
//  NearbyPostingsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "NearbyPostingsViewController.h"
#import "NearbyPostCell.h"
#import "PostDetailsViewController.h"

@interface NearbyPostingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *nearbyPostTableView;
@property (strong, nonatomic) NSArray * nearbyPostingsArray;

@end

@implementation NearbyPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nearbyPostTableView.delegate=self;
    self.nearbyPostTableView.dataSource=self;
    self.nearbyPostingsArray=[[NSArray alloc]init];
    [self fetchNearbyPosts];
    UIRefreshControl * refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self setDefinesPresentationContext:YES];
    [self.nearbyPostTableView insertSubview:refreshControl atIndex:0];
    self.nearbyPostTableView.rowHeight=75;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)fetchNearbyPosts{
    PFQuery * query=[PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"title"];
    [query includeKey: @"author"];
    [query includeKey: @"summary"];
    [query includeKey: @"location"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * posts, NSError*error){
        if(posts!=nil){
            self.nearbyPostingsArray=posts;
            [self.nearbyPostTableView reloadData];
        } else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NearbyPostCell * nearbyPostCell=[tableView dequeueReusableCellWithIdentifier:@"NearbyPostCell" forIndexPath:indexPath];
    Post * post=self.nearbyPostingsArray[indexPath.row];
    nearbyPostCell.post=post;
    [nearbyPostCell setNearbyPost:post];
    return nearbyPostCell;
                                   
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nearbyPostingsArray.count;
}

-(void)beginRefresh:(UIRefreshControl *)refreshControl{
    //fetch all of the nearby posts
    [self fetchNearbyPosts];
    //tell the refresh control to stop spinning
    [refreshControl endRefreshing];
}
 #pragma mark - Navigation
 

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:@"cellToPostDetailsSegue"]){
         UITableViewCell * tappedCell=sender;
         NSIndexPath *indexPath=[self.nearbyPostTableView indexPathForCell:tappedCell];
         Post * singlePost=self.nearbyPostingsArray[indexPath.row];
         NSLog(@"%@", singlePost);
         PostDetailsViewController *postDetailsViewController=[segue destinationViewController];
         postDetailsViewController.post=singlePost;
     }
 }



@end
