//
//  ComposeNewPostViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ComposeNewPostViewController.h"
#import "Post.h"

@interface ComposeNewPostViewController ()
@end

@implementation ComposeNewPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didTapCancelButton:(id)sender {
    [self performSegueWithIdentifier:@"cancelComposeSegue" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapPostButton:(id)sender {
    [Post postJob:self.enteredTitle.text withSummary:self.enteredDescription.text withLocation:nil
       withImages:nil withDate:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error){
           if(succeeded){
               NSLog(@"Shared Successfully");
           } else{
               NSLog(@"%@", error.localizedDescription);
           }
           
       }];
    
    [self performSegueWithIdentifier:@"backToPersonalFeedSegue" sender:nil];
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
