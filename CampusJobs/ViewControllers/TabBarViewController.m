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
#import "Colors.h"

@interface TabBarViewController () <MDCTabBarControllerDelegate>
@property (strong,nonatomic) MDCTabBar *tabBar;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
    // Do any additional setup after loading the view.
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionBottom;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBar{
    //initialize tab bar
    MDCTabBar *tabBar = [[MDCTabBar alloc] initWithFrame:self.view.bounds];
    self.tabBar.delegate = self;
    //delcare tab bar items
    tabBar.items = @[
                     [[UITabBarItem alloc] initWithTitle:@"FEED" image:[UIImage imageNamed:@"iconmonstr-home-4-24"] tag:0],
                     [[UITabBarItem alloc] initWithTitle:@"CHAT" image:[UIImage imageNamed:@"iconmonstr-speech-bubble-28-24"] tag:1], [[UITabBarItem alloc] initWithTitle:@"PROFILE" image:[UIImage imageNamed:@"iconmonstr-user-2-24"] tag:2],
                     ];
    tabBar.itemAppearance = MDCTabBarItemAppearanceTitledImages;
    tabBar.autoresizingMask =
    UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [tabBar sizeToFit];
    tabBar.frame=CGRectMake(0, 623-tabBar.frame.size.height, self.view.frame.size.width, tabBar.frame.size.height);
    
    //set view controllers for each selected tab
    FeedViewController *tab1 = [self.storyboard instantiateViewControllerWithIdentifier:@"feed"];
    ConversationsViewController *tab2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Chat"];
    MainProfileViewController *tab3 = [self.storyboard instantiateViewControllerWithIdentifier:@"mainProfileViewController"];
    
    //format tab bar
    tabBar.tintColor=[Colors primaryOrangeColor];
    tabBar.backgroundColor=[Colors secondaryGreyLightColor];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:tab1, tab2, tab3, nil];
    self.viewControllers=viewControllers;
    self.selectedViewController=viewControllers[0];
    
    self.tabBar = tabBar;
    [self.view addSubview:self.tabBar];
    
    
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
