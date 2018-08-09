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
#import "StringConstants.h"
#import "Utils.h"
#import "Colors.h"
#import <ChameleonFramework/Chameleon.h>
#import "Format.h"

@interface NearbyPostingsViewController () <UITableViewDelegate, UITableViewDataSource, PostDetailsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nearbyPostTableView;
@property (retain, nonatomic) NSMutableArray * nearbyPostingsArray;
@property (strong, nonatomic) PFUser * currentUser;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) NSNumber * userRadius;
@property (weak, nonatomic) IBOutlet UIView *noNearbyPostingsView;
@property (weak, nonatomic) IBOutlet UILabel *noNearbyPostingsLabel;

@end

@implementation NearbyPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nearbyPostTableView.delegate=self;
    self.nearbyPostTableView.dataSource=self;
    
    self.nearbyPostingsArray=[[NSMutableArray alloc]init];
    
    [self addRefreshControl];
    [self displayBackgroundColor];
    [self displayRadius];
    
    [self fetchNearbyPosts];
    [self.nearbyPostTableView reloadData];
    
    self.noNearbyPostingsView.frame = self.view.bounds;
    [Format configurePlaceholderView:self.noNearbyPostingsView withLabel:self.noNearbyPostingsLabel];
    self.noNearbyPostingsLabel.text = @"LOADING NEARBY POSTINGS...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat verticalInset = 8;
    self.radiusLabel.frame = CGRectMake(0, verticalInset, self.view.frame.size.width, 20);
    self.nearbyPostTableView.frame = CGRectMake(0, self.radiusLabel.frame.size.height + 2 * verticalInset, self.view.frame.size.width, self.view.frame.size.height - self.radiusLabel.frame.size.height);
    
    [self displayRadius];
    [self fetchNearbyPosts];
    [self.nearbyPostTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchNearbyPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //convert desired radius into a double
    NSNumber *desiredRadius = self.currentUser[@"desiredRadius"];
    double desiredRadiusDouble=[desiredRadius doubleValue];
    
    [query orderByDescending:@"createdAt"];
    //user's current location
    PFGeoPoint *currentLocation = self.currentUser[@"currentLocation"];
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
            
            if (self.nearbyPostingsArray.count > 0) {
                self.noNearbyPostingsView.hidden = YES;
            } else {
                self.noNearbyPostingsView.hidden = NO;
                self.noNearbyPostingsLabel.text = [NSString stringWithFormat:@"No postings within %.2f miles of you. Change your desired radius in settings to widen the scope!", [self.userRadius floatValue]];
                [self.noNearbyPostingsLabel setTextAlignment:NSTextAlignmentLeft];
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

//Visual formatting for each cell
//Creates spaces in between the cells, creates round corners, adds cell shadow and cell color
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.nearbyPostTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nearbyPostTableView.rowHeight=75;
    cell.layer.backgroundColor=[[UIColor clearColor]CGColor];
    //initializes white rounded cell
    UIView  *roundedCellView = [[UIView alloc]initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-10, 105)];
    CGFloat colors[]={1.0, 1.0, 1.0, 1.0};
    roundedCellView.layer.backgroundColor=CGColorCreate(CGColorSpaceCreateDeviceRGB(), colors);;
    roundedCellView.layer.masksToBounds=false;
    //add border color
    roundedCellView.layer.borderWidth=.5;
    roundedCellView.layer.borderColor=[[Colors primaryBlueColor]CGColor];
    //rounded edges
    roundedCellView.layer.cornerRadius=3.0;
    //adding shadow
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
    return 115;
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
    self.userRadius=self.currentUser[desiredRadius];
    floatRadius=[self.userRadius floatValue];
    self.radiusLabel.text=[NSString stringWithFormat:@"POSTS WITHIN %.2f MILES",floatRadius];
}

//Displays the background color
- (void)displayBackgroundColor{
    self.view.backgroundColor=[Colors secondaryGreyLighterColor];
    self.nearbyPostTableView.backgroundColor=[Colors secondaryGreyLighterColor];
}

- (void)addRefreshControl{
    UIRefreshControl * refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.nearbyPostTableView insertSubview:refreshControl atIndex:0];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:nearbyPostingsToPostDetailsSegue]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.nearbyPostTableView indexPathForCell:tappedCell];
        Post *singlePost = self.nearbyPostingsArray[indexPath.row];
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        [self.nearbyPostTableView deselectRowAtIndexPath:indexPath animated:YES];
        postDetailsViewController.delegate = self;
        postDetailsViewController.post = singlePost;
    }
}

@end
