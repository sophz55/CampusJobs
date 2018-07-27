//
//  HomeViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.NameButton.layer.cornerRadius = 5;
    self.EmailButton.layer.cornerRadius = 5;
    self.AddressButton.layer.cornerRadius = 5;
    self.CreditCardButton.layer.cornerRadius = 5;
    self.RatingButton.layer.cornerRadius = 5;
    
    
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)Name:(id)sender {
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:2];
    
}

- (IBAction)Email:(id)sender {
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:3];
    
}

- (IBAction)Address:(id)sender {
    
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:1];
    
    
}

- (IBAction)CreditCard:(id)sender {
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:4];
    
    
}

- (IBAction)Rating:(id)sender {
}
@end
