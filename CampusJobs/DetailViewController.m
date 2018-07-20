//
//  DetailViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/19/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.DetailModal);
    self.DetailTitle.text = _DetailModal[0];
//    self.DetailTitle.text = _DetailModal[1];
    self.DetailImageView.image = [UIImage imageNamed:_DetailModal[2]];
    
    self.navigationItem.title = _DetailModal[0];
    
    
    if ([self.DetailTitle.text isEqualToString:@"Profile"])
    
    {
        self.Fullname.text = @"Somto Nweke";
        self.Password.text = @"Happyatfacebook12";
        self.Rating.text = @"Fair";
        self.Address.text = @"1 Hacker way";
        
    }
    
    
    
    if ([self.DetailTitle.text isEqualToString:@"Settings"])
    {
        self.Fullname.text = @"Fullname";
        self.Password.text = @"Password";
        self.Rating.text = @"Rating";
        self.Address.text = @"Address";
        
    }
    
    
    if ([self.DetailTitle.text isEqualToString:@"Payments"])
    {
        self.Fullname.text = @"Fullname";
        self.Password.text = @"Password";
        self.Rating.text = @"Rating";
        self.Address.text = @"Address";
        
    }
    
    
    
    if ([self.DetailTitle.text isEqualToString:@"Contact"])
    {
        self.Fullname.text = @"Fullname";
        self.Password.text = @"Password";
        self.Rating.text = @"Rating";
        self.Address.text = @"Address";
        
    }
    
    
    
    if ([self.DetailTitle.text isEqualToString:@"Lists"])
    {
        self.Fullname.text = @"Fullname";
        self.Password.text = @"Password";
        self.Rating.text = @"Rating";
        self.Address.text = @"Address";
        
    }
    
    
    
    
   
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

@end
