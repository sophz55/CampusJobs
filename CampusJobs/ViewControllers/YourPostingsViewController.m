//
//  YourPostingsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "YourPostingsViewController.h"

@interface YourPostingsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *previousPostTableView;
@property (strong, nonatomic) NSArray * previousPostsArray;

@end

@implementation YourPostingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of/Users/szheng/Desktop/CampusJobs/CampusJobs/Models/Post.h any resources that can be recreated.
}


-(void)fetchPreviousUserPosts{
    PFQuery * query=[PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query includeKey:@"taker"];
    [query includeKey:@"completedDate"];
    [query includeKey: @"title"];
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
