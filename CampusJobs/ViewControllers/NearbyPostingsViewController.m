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
#import "SegueConstants.h"

@interface NearbyPostingsViewController () <UITableViewDelegate, UITableViewDataSource, PostDetailsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nearbyPostTableView;
@property (strong, nonatomic) NSArray * nearbyPostingsArray;
@property (strong, nonatomic) PFUser * currentUser;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) NSNumber * userRadius;

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
    [self.nearbyPostTableView insertSubview:refreshControl atIndex:0];
    self.nearbyPostTableView.rowHeight=75;
    [self displayRadius];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)fetchNearbyPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    //user's current location
    PFGeoPoint * currentLocation =self.currentUser[@"currentLocation"];
    [query includeKey:@"title"];
    [query includeKey:@"author"];
    [query includeKey:@"summary"];
    [query includeKey:@"postStatus"];
    [query whereKey:@"postStatus" equalTo:@0]; // postStatus is enum type status with 0 = OPEN
    
    //filter based on the radius selected by the user (based on user radius and post location)
    [query whereKey:@"location" nearGeoPoint:(currentLocation) withinMiles:[self.userRadius doubleValue]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * posts, NSError*error){
        if (posts != nil) {
            self.nearbyPostingsArray = posts;
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

- (void)displayRadius{
    //self.desiredRadiusLabel.text=[NSString stringWithFormat:@"%.2f",self.radiusSliderBar.value];
    float floatRadius;
    self.currentUser=[PFUser currentUser];
    self.userRadius=self.currentUser[@"desiredRadius"];
    floatRadius=[self.userRadius floatValue];
    self.radiusLabel.text=[NSString stringWithFormat:@"%.2f",floatRadius];
}

 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if([segue.identifier isEqualToString:nearbyPostingsToPostDetailsSegue]){
         UITableViewCell * tappedCell=sender;
         NSIndexPath *indexPath=[self.nearbyPostTableView indexPathForCell:tappedCell];
         Post * singlePost=self.nearbyPostingsArray[indexPath.row];
         UINavigationController *nearbyNavigationController = [segue destinationViewController];
         PostDetailsViewController *postDetailsViewController = (PostDetailsViewController *)[nearbyNavigationController topViewController];
         postDetailsViewController.delegate = self;
         postDetailsViewController.post = singlePost;
     }
 }

@end
