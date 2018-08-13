//
//  BottomNavigationBarViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 8/9/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "BottomNavigationBarViewController.h"
#import <MaterialComponents/MaterialBottomNavigation.h>
#import "FeedViewController.h"
#import "ConversationsViewController.h"
#import "MainProfileViewController.h"
#import "Colors.h"
#import "StringConstants.h"

@interface BottomNavigationBarViewController () <MDCBottomNavigationBarDelegate>

@property (strong, nonatomic) IBOutlet MDCBottomNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *conversationsViewContainer;
@property (weak, nonatomic) IBOutlet UIView *feedViewContainer;
@property (weak, nonatomic) IBOutlet UIView *profileViewContainer;

@end

@implementation BottomNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureBottomNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureBottomNavigationBar {
    NSString * feedIcon=@"iconmonstr-home-4-24";
    NSString * messagesIcon=@"iconmonstr-speech-bubble-28-24";
    NSString * profileIcon=@"iconmonstr-user-2-24";
    
    //initialize tab bar
    self.navigationBar = [[MDCBottomNavigationBar alloc] initWithFrame:self.view.bounds];
    
    self.navigationBar.titleVisibility = MDCBottomNavigationBarTitleVisibilitySelected;
    self.navigationBar.alignment = MDCBottomNavigationBarAlignmentJustifiedAdjacentTitles;
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UITabBarItem *tabBarItem1 =
    [[UITabBarItem alloc] initWithTitle:@"FEED"
                                  image:[UIImage imageNamed:feedIcon]
                                    tag:0];
    UITabBarItem *tabBarItem2 =
    [[UITabBarItem alloc] initWithTitle:@"CHAT"
                                  image:[UIImage imageNamed:messagesIcon]
                                    tag:0];
    UITabBarItem *tabBarItem3 =
    [[UITabBarItem alloc] initWithTitle:@"PROFILE"
                                  image:[UIImage imageNamed:profileIcon]
                                    tag:0];
    
    self.navigationBar.items = @[tabBarItem1, tabBarItem2, tabBarItem3];
    [self.navigationBar sizeToFit];
    self.navigationBar.selectedItemTitleColor=[Colors primaryBlueDarkColor];
    
    CGSize navigationBarSize = [self.navigationBar sizeThatFits:self.view.bounds.size];
    self.navigationBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - navigationBarSize.height, navigationBarSize.width, navigationBarSize.height);
    
    self.feedViewContainer.frame = CGRectMake(0, 0, self.view.frame.size.width, CGRectGetHeight(self.view.bounds) - navigationBarSize.height);
    self.conversationsViewContainer.frame = self.feedViewContainer.frame;
    self.profileViewContainer.frame = self.feedViewContainer.frame;
    
    //format navigation bar colors and font
    self.navigationBar.barTintColor=[Colors secondaryGreyLighterColor];
    self.navigationBar.itemTitleFont=[UIFont fontWithName:regularFontName size:10];
    self.navigationBar.selectedItemTintColor=[UIColor grayColor];
    
    [self.navigationBar setSelectedItem:self.navigationBar.items[0]];
    [self bottomNavigationBar:self.navigationBar didSelectItem:self.navigationBar.selectedItem];
}

- (void)bottomNavigationBar:(MDCBottomNavigationBar *)bottomNavigationBar didSelectItem:(UITabBarItem *)item {
    [bottomNavigationBar setSelectedItem:item];
    if(bottomNavigationBar.selectedItem==bottomNavigationBar.items[0]){
        self.feedViewContainer.hidden = NO;
        self.conversationsViewContainer.hidden = YES;
        self.profileViewContainer.hidden = YES;
    } else if(bottomNavigationBar.selectedItem==bottomNavigationBar.items[1]){
        self.feedViewContainer.hidden = YES;
        self.conversationsViewContainer.hidden = NO;
        self.profileViewContainer.hidden = YES;
    } else{
        self.feedViewContainer.hidden = YES;
        self.conversationsViewContainer.hidden = YES;
        self.profileViewContainer.hidden = NO;
    }
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
