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
#import "Utils.h"
#import "Colors.h"

@interface NearbyPostingsViewController () <UITableViewDelegate, UITableViewDataSource, PostDetailsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nearbyPostTableView;
@property (retain, nonatomic) NSMutableArray * nearbyPostingsArray;
@property (strong, nonatomic) PFUser * currentUser;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) NSNumber * userRadius;

@end

@implementation NearbyPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nearbyPostTableView.delegate=self;
    self.nearbyPostTableView.dataSource=self;
    self.nearbyPostingsArray=[[NSMutableArray alloc]init];
    [self fetchNearbyPosts];
    [self.nearbyPostTableView reloadData];
    UIRefreshControl * refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.nearbyPostTableView insertSubview:refreshControl atIndex:0];
    self.nearbyPostTableView.rowHeight=75;
    [self displayRadius];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchNearbyPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //convert desired radius into a double
    NSNumber* desiredRadius =self.currentUser[@"desiredRadius"];
    double desiredRadiusDouble=[desiredRadius doubleValue];
    
    [query orderByDescending:@"createdAt"];
    //user's current location
    PFGeoPoint * currentLocation =self.currentUser[@"currentLocation"];
    [query includeKey:@"title"];
    [query includeKey:@"author"];
    [query includeKey:@"summary"];
    [query includeKey:@"postStatus"];
    [query includeKey:@"location"];
    [query whereKey:@"postStatus" equalTo:@0]; // postStatus is enum type status with 0 = OPEN
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * posts, NSError*error){
        if (posts != nil) {
            self.nearbyPostingsArray=[[NSMutableArray alloc]init];
            //Loop through all of the posts in order to filter by the desired radius
            for(int i=0; i<[posts count];i++){
                Post * currPost=[posts objectAtIndex:i];
                PFGeoPoint * postGeoPoint=currPost[@"location"];
                //calculate distance between post location and user location
                double calculatedDistance=[Utils calculateDistance:postGeoPoint betweenUserandPost:currentLocation];
                //if the calculated distance (miles) is less than the desired radius, add to postings array
                if(calculatedDistance <= desiredRadiusDouble){
                    [self.nearbyPostingsArray addObject:currPost];
                }
            }
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

- (void)beginRefresh:(UIRefreshControl *)refreshControl{
    //fetch all of the nearby posts
    [self fetchNearbyPosts];
    //tell the refresh control to stop spinning
    [refreshControl endRefreshing];
}

- (void)reloadData {
    [self fetchNearbyPosts];
}

- (void)displayRadius{
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
