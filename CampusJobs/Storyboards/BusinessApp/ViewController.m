//
//  ViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.button1.layer.cornerRadius = 10;
    self.button2.layer.cornerRadius = 10;
    self.button3.layer.cornerRadius = 10;
    self.button4.layer.cornerRadius = 10;
    self.button5.layer.cornerRadius = 10;
    
    [[self navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)Jobs:(id)sender {
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:2];
    
}

- (IBAction)portfolio:(id)sender {
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:3];
    
    
}

- (IBAction)Bio:(id)sender:(id)sender {
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:1];
    
    
}

- (IBAction)Contact:(id)sender {
    
    [(UITabBarController *) self.tabBarController setSelectedIndex:4];
    
    
}
- (IBAction)Social:(id)sender {
}

@end
