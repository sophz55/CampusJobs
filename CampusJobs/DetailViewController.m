//
//  DetailViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/19/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "DetailViewController.h"
#define k_Save @"Save"
#import <Parse.h>


@interface DetailViewController ()


@end

@implementation DetailViewController

@synthesize device;

-(NSManagedObjectContext *)managedObjectContext{
    
    NSManagedObjectContext *context =nil;
    id delegate = [[UIApplication sharedApplication]delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]){
        context = [delegate managedObjectContext];
                   }
                   return context;
                   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    NSUserDefaults *savedapp = [NSUserDefaults standardUserDefaults];
    bool saved =[savedapp boolForKey:k_Save];
    if (!saved){
        ///not saved
        
       
       

}
    
    
    
    
    NSLog(@"%@",self.DetailModal);
    self.DetailTitle.text = _DetailModal[0];
//    self.DetailTitle.text = _DetailModal[1];
    self.DetailImageView.image = [UIImage imageNamed:_DetailModal[2]];
    
    self.navigationItem.title = _DetailModal[0];
    
    
    //if ([self.DetailTitle.text isEqualToString:@"Profile"])
    
   // {
        // ** self.Fullname.text = @"Somto Nweke";
        
        //self.Password.text = @"Happyatfacebook12";
        //self.Rating.text = @"Fair";
       // self.Address.text = @"1 Hacker way";
        
        
   // }
    
    
   // if ([self.DetailTitle.text isEqualToString:@"Settings"])
  //  {
    //    self.Fullname.text = @"Fullname";
  //      self.Password.text = @"Password";
   //     self.Rating.text = @"Rating";
   //     self.Address.text = @"Address";
        
   // }
    
    
   // if ([self.DetailTitle.text isEqualToString:@"Payments"])
 //   {
 //       self.Fullname.text = @"Fullname";
 //       self.Password.text = @"Password";
  //      self.Rating.text = @"Rating";
   //     self.Address.text = @"Address";
        
 //   }
    
    
    
  //  if ([self.DetailTitle.text isEqualToString:@"Contact"])
  //  {
    //    self.Fullname.text = @"Fullname";
   //     self.Password.text = @"Password";
    //    self.Rating.text = @"Rating";
   //     self.Address.text = @"Address";
        
  //  }
    
    
    
 ///   if ([self.DetailTitle.text isEqualToString:@"Lists"])
 //   {
 //       self.Fullname.text = @"Fullname";
//        self.Password.text = @"Password";
 //       self.Rating.text = @"Rating";
  //      self.Address.text = @"Address";
        
  //  }
    
    
    
    
   
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


- (IBAction)SaveData:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    
    user.username = self.FirstName.text;
    
    user.email = self.LastName.text;
    
    user.password = self.Username.text;

    [user saveInBackground];
    
    
    
    
    //newUser[@"name"] = self.nameField.text;
    //newUser[@"address"] = @"";
    
    
}




- (IBAction)DismissKeyboard:(id)sender {
    
    [self resignFirstResponder];
    
  
    
}


    
    

@end
