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

@interface NearbyPostingsViewController () <UITableViewDelegate, UITableViewDataSource, PostDetailsDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *nearbyPostTableView;
@property (retain, nonatomic) NSMutableArray * nearbyPostingsArray;
@property (strong, nonatomic) PFUser * currentUser;
@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (strong, nonatomic) NSNumber * userRadius;
@property (weak, nonatomic) IBOutlet UIView *noNearbyPostingsView;
@property (weak, nonatomic) IBOutlet UILabel *noNearbyPostingsLabel;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSMutableArray * filteredNearbyPostingsArray;

@end

@implementation NearbyPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDelegates];
    self.nearbyPostingsArray=[[NSMutableArray alloc]init];
    self.filteredNearbyPostingsArray=[[NSMutableArray alloc]init];
    self.noNearbyPostingsView.frame = self.view.bounds;
    [Format configurePlaceholderView:self.noNearbyPostingsView withLabel:self.noNearbyPostingsLabel];
    self.noNearbyPostingsView.frame = self.view.bounds;
    self.noNearbyPostingsLabel.text = @"LOADING NEARBY POSTINGS...";
    [self callViewDidLoadMethods];
    self.noNearbyPostingsView.frame = self.view.bounds;
    [Format configurePlaceholderView:self.noNearbyPostingsView withLabel:self.noNearbyPostingsLabel];
    self.noNearbyPostingsLabel.text = @"LOADING NEARBY POSTINGS...";
    self.nearbyPostingsArray=[[NSMutableArray alloc]init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self displayRadius];
    [self displayRadius];
    [self fetchNearbyPosts];
    [self.nearbyPostTableView reloadData];
    
    self.searchBar.frame=CGRectMake(0, 0, self.searchBar.frame.size.width, 45);
    self.radiusLabel.frame=CGRectMake(0, 48, self.radiusLabel.frame.size.width, self.radiusLabel.frame.size.height);
    self.nearbyPostTableView.frame=CGRectMake(0, 63, self.nearbyPostTableView.frame.size.width, self.nearbyPostTableView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setDelegates{
    self.nearbyPostTableView.delegate=self;
    self.nearbyPostTableView.dataSource=self;
    self.searchBar.delegate=self;
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
    [query whereKey:@"author" notEqualTo:[PFUser currentUser]];
    [query includeKey:@"summary"];
    [query includeKey:@"postStatus"];
    [query includeKey:@"location"];
    [query whereKey:@"postStatus" equalTo:@0]; // postStatus is enum type status with 0 = OPEN
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * posts, NSError*error){
        if (posts != nil) {
            if (posts.count > 0) {
                self.noNearbyPostingsView.hidden = YES;
            } else {
                self.noNearbyPostingsView.hidden = NO;
                self.noNearbyPostingsLabel.text = [NSString stringWithFormat:@"No postings within %.1f miles of you. Change your desired radius in settings to widen the scope.", [self.userRadius floatValue]];
                [self.noNearbyPostingsLabel setTextAlignment:NSTextAlignmentLeft];
            }
            self.nearbyPostingsArray=[[NSMutableArray alloc]init];
            self.filteredNearbyPostingsArray=[[NSMutableArray alloc]init];
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
            self.filteredNearbyPostingsArray=self.nearbyPostingsArray;
            if (self.nearbyPostingsArray.count > 0) {
                self.noNearbyPostingsView.hidden = YES;
            } else {
                self.noNearbyPostingsView.hidden = NO;
                self.noNearbyPostingsLabel.text = [NSString stringWithFormat:@"No postings within %.1f miles of you. Change your desired radius in settings to widen the scope.", [self.userRadius floatValue]];
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
    Post * post=self.filteredNearbyPostingsArray[indexPath.row];
    nearbyPostCell.post=post;
    [nearbyPostCell setNearbyPost:post];
    //adding shadow
    nearbyPostCell.layer.shadowOffset=CGSizeMake(0, 0);
    nearbyPostCell.layer.shadowOpacity=0.3;
    nearbyPostCell.layer.shadowRadius=2.0;
    nearbyPostCell.clipsToBounds = false;
    nearbyPostCell.layer.shadowColor=[[UIColor blackColor]CGColor];
    return nearbyPostCell;
}

//Visual formatting for each cell
//Creates spaces in between the cells, creates round corners, adds cell shadow and cell color
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    self.nearbyPostTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nearbyPostTableView.rowHeight=75;
    cell.layer.backgroundColor=[[UIColor clearColor]CGColor];
    //initializes white rounded cell
    UIView  *roundedCellView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 105)];
    CGFloat colors[]={1.0, 1.0, 1.0, 1.0};
    roundedCellView.layer.backgroundColor=CGColorCreate(CGColorSpaceCreateDeviceRGB(), colors);;
    roundedCellView.layer.masksToBounds=false;
    //rounded edges
    roundedCellView.layer.cornerRadius=5.0;
    //adds rounded cell to each cell content view
    [cell.contentView addSubview:roundedCellView];
    [cell.contentView sendSubviewToBack:roundedCellView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredNearbyPostingsArray.count;
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
    self.radiusLabel.text=[NSString stringWithFormat:@"POSTS WITHIN %.1f MILES",floatRadius];
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

-(void)searchBar:(UISearchBar *) searchBar textDidChange: (NSString *) searchText{
    if(searchText.length!=0){
        NSPredicate * predicate=[NSPredicate predicateWithBlock:^BOOL(Post * post, NSDictionary * bindings){
            return[post[@"title"] containsString:searchText];
        }];
        self.filteredNearbyPostingsArray=[self.nearbyPostingsArray filteredArrayUsingPredicate:predicate];
    } else{
        self.filteredNearbyPostingsArray=self.nearbyPostingsArray;
        [self.nearbyPostTableView reloadData];
    }
    [self.nearbyPostTableView reloadData];
}

- (void)changeSearchBarFont{
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:17]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.nearbyPostingsArray=self.nearbyPostingsArray;
    [self.view endEditing:YES];
    searchBar.text=@"";
    [self.nearbyPostTableView reloadData];
}

//Helper method for view did load
- (void)callViewDidLoadMethods{
    [self addRefreshControl];
    [self displayBackgroundColor];
    [self fetchNearbyPosts];
    [self.nearbyPostTableView reloadData];
    [self changeSearchBarFont];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:nearbyPostingsToPostDetailsSegue]) {
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.nearbyPostTableView indexPathForCell:tappedCell];
        Post *singlePost = self.filteredNearbyPostingsArray[indexPath.row];
        PostDetailsViewController *postDetailsViewController = [segue destinationViewController];
        [self.nearbyPostTableView deselectRowAtIndexPath:indexPath animated:YES];
        postDetailsViewController.delegate = self;
        postDetailsViewController.post = singlePost;
    }
}

@end
