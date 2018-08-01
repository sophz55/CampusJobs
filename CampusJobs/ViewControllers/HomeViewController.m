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
    
    self.NameButton.layer.cornerRadius = 10;
    self.EmailButton.layer.cornerRadius =10;
    self.AddressButton.layer.cornerRadius = 10;
   self.CreditCardButton.layer.cornerRadius = 10;
    
    
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
    
    
    
}

- (IBAction)Email:(id)sender {
   
    
}

- (IBAction)Address:(id)sender {
    
    
   
    
    
}

- (IBAction)CreditCard:(id)sender {
    
   
    
    
}


@end
