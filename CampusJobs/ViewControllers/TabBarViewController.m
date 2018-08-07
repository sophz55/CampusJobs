//
//  TabBarViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 8/6/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "TabBarViewController.h"
#import "FeedViewController.h"
#import "ConversationsViewController.h"
#import "MainProfileViewController.h"
#import "MaterialBottomNavigation.h"
#import "Colors.h"
#import "MaterialBottomNavigation+ColorThemer.h"
#import "AppScheme.h"

@interface TabBarViewController () <MDCBottomNavigationBarDelegate>
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBottomNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initBottomNavigationBar{
    NSString * feedIcon=@"iconmonstr-home-4-24";
    NSString * messagesIcon=@"iconmonstr-speech-bubble-28-24";
    NSString * profileIcon=@"iconmonstr-user-2-24";
    CGFloat tabBarHeight=60;
    CGFloat viewHeight=607;
    
    //initialize tab bar
    MDCBottomNavigationBar *navigationBar = [[MDCBottomNavigationBar alloc] initWithFrame:self.view.bounds];
    navigationBar.delegate = self;
    //delcare tab bar items
    navigationBar.items = @[
                            [[UITabBarItem alloc] initWithTitle:@"FEED" image:[UIImage imageNamed:feedIcon] tag:0],
                            [[UITabBarItem alloc] initWithTitle:@"CHAT" image:[UIImage imageNamed:messagesIcon] tag:1],
                            [[UITabBarItem alloc] initWithTitle:@"PROFILE" image:[UIImage imageNamed:profileIcon] tag:2]
                            ];
    navigationBar.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [navigationBar sizeToFit];
    navigationBar.frame=CGRectMake(0, viewHeight, self.view.frame.size.width, tabBarHeight);
    
    //set view controllers for each selected tab
    FeedViewController *tab1 = [self.storyboard instantiateViewControllerWithIdentifier:@"feed"];
    ConversationsViewController *tab2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    MainProfileViewController *tab3 = [self.storyboard instantiateViewControllerWithIdentifier:@"mainProfileViewController"];
    NSArray *viewControllers = [NSArray arrayWithObjects:tab1, tab2, tab3, nil];
    self.viewControllers=viewControllers;
    self.selectedViewController=viewControllers[0];
    [self.view addSubview:navigationBar];
    
    //format navigation bar colors and font
    navigationBar.barTintColor=[Colors secondaryGreyLighterColor];
    navigationBar.itemTitleFont=[UIFont fontWithName:@"RobotoCondensed-Regular" size:10];
    navigationBar.selectedItemTintColor=[UIColor grayColor];
}

//bottomNavigationBar delegate
- (void)bottomNavigationBar:(nonnull MDCBottomNavigationBar *)bottomNavigationBar
              didSelectItem:(id)item{
    NSLog(@"%@", bottomNavigationBar.selectedItem);
    if(bottomNavigationBar.selectedItem==bottomNavigationBar.items[0]){
        self.selectedViewController=self.viewControllers[0];
    } else if(bottomNavigationBar.selectedItem==bottomNavigationBar.items[1]){
        self.selectedViewController=self.viewControllers[1];
    } else{
        self.selectedViewController=self.viewControllers[2];
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
