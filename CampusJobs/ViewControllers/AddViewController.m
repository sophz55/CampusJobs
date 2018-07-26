//
//  AddViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "AddViewController.h"
#import <CoreData/CoreData.h>
#import "Parse.h"

@interface AddViewController ()

//make a property of pf user  type
@property (strong,nonatomic)PFUser *currentuser;


@end

@implementation AddViewController


@synthesize device;

-(NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.device) {
        [self.Name setText:[self.device valueForKey:@"text1"]];
        [self.Email setText:[self.device valueForKey:@"text2"]];
        [self.Address setText:[self.device valueForKey:@"text3"]];
    }
    
    
    self.currentuser = [PFUser currentUser];
    

    self.Name.text = self.currentuser[@"name"];
    
    
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

- (IBAction)DismissKeyboard:(id)sender {
     [self resignFirstResponder];
}

- (IBAction)SaveData:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.device) {
        [self.device setValue:self.Name.text forKey:@"text1"];
        [self.device setValue:self.Email.text forKey:@"text2"];
        [self.device setValue:self.Address.text forKey:@"text3"];
    } else {
        
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        
        [UIDevice setValue:self.Name.text forKey:@"text1"];
        [UIDevice setValue:self.Email.text forKey:@"text2"];
        [UIDevice setValue:self.Address.text forKey:@"text3"];
        
    }
    
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"%@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
