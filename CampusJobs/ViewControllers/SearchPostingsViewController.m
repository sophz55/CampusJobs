//
//  SearchPostingsViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 8/13/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SearchPostingsViewController.h"
#import "Post.h"
#import <MaterialComponents/MaterialAppBar.h>
#import "Format.h"
#import "NearbyPostCell.h"
#import "PreviousUserPostCell.h"
#import <Masonry.h>
#import "Utils.h"

@interface SearchPostingsViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchedPostingsTableView;
@property (retain, nonatomic) NSMutableArray *searchedPostingsArray;
@property (strong, nonatomic) UIBarButtonItem *backButton;

@end

@implementation SearchPostingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchedPostingsTableView.delegate = self;
    self.searchedPostingsTableView.dataSource = self;
    
    self.searchedPostingsArray = [[NSMutableArray alloc] init];
    
    self.searchBar.delegate = self;
    [self changeSearchBarFont];

    [self configureTopNavigationBar];
    [self configureLayout];
    [self.searchedPostingsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom configuration

- (void)configureTopNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton:)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    if (self.isSearchingNearby) {
        [Format formatAppBar:self.appBar withTitle:@"Search Nearby Postings"];
    } else {
        [Format formatAppBar:self.appBar withTitle:@"Search Your Postings"];
    }
    
    self.view.backgroundColor = self.appBar.headerViewController.view.backgroundColor;
}

- (void)configureLayout {
    self.searchBar.frame = CGRectMake(0, self.appBar.headerViewController.view.frame.origin.y + self.appBar.headerViewController.view.frame.size.height, self.searchBar.frame.size.width, 45);
    CGFloat tableViewOriginY = self.searchBar.frame.origin.y + self.searchBar.frame.size.height;
    self.searchedPostingsTableView.frame = CGRectMake(0, tableViewOriginY, self.view.frame.size.width, self.view.frame.size.height - tableViewOriginY);
}

#pragma mark - UISearchBar

-(void)searchBar:(UISearchBar *) searchBar textDidChange: (NSString *) searchText{
    if(searchText.length!=0){
        NSPredicate *predicate=[NSPredicate predicateWithBlock:^BOOL(Post *post, NSDictionary *bindings){
            return[post[@"title"] containsString:searchText];
        }];
        self.searchedPostingsArray = [[NSMutableArray alloc] initWithArray:[self.allPostingsArray filteredArrayUsingPredicate:predicate]];
    } else {
        self.searchedPostingsArray = self.allPostingsArray;
    }
    [self.searchedPostingsTableView reloadData];
}

//changes the font of the search bar text
- (void)changeSearchBarFont{
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"RobotoCondensed-Regular" size:17]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchedPostingsArray = self.allPostingsArray;
    [self.view endEditing:YES];
    searchBar.text=@"";
    [self.searchedPostingsTableView reloadData];
}

#pragma mark - UITableView

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.isSearchingNearby) {
        NearbyPostCell *postCell = [tableView dequeueReusableCellWithIdentifier:@"NearbyPostCell" forIndexPath:indexPath];
        Post *post = self.searchedPostingsArray[indexPath.row];
        postCell.post = post;
        [postCell setNearbyPost:post];
        [Format configureCellShadow:postCell];
        return postCell;
    } else {
        PreviousUserPostCell *postCell = [tableView dequeueReusableCellWithIdentifier:@"YourPostCell" forIndexPath:indexPath];
        Post *post=self.searchedPostingsArray[indexPath.row];
        postCell.previousPost=post;
        [postCell setPreviousPost:post];
        [Format configureCellShadow:postCell];
        return postCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSearchingNearby) {
        return 115;
    } else {
        return 90;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchedPostingsArray.count;
}

#pragma mark - IBAction

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
