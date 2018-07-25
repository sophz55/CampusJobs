//
//  CreditViewController.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "CreditViewController.h"
#import <CoreData/CoreData.h>

@interface CreditViewController ()

@end

@implementation CreditViewController

@synthesize device;

-(NSManagedObjectContext *)managedObjectContext {
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

- (IBAction)DismissKeyboard:(id)sender {
}


- (IBAction)SaveData:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (self.device) {
        [self.device setValue:self.CardNumber.text forKey:@"text1"];
        [self.device setValue:self.Expiration.text forKey:@"text2"];
        [self.device setValue:self.Security.text forKey:@"text3"];
        [self.device setValue:self.BillingCode.text forKey:@"text3"];
        
        
    } else {
        
        NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Device" inManagedObjectContext:context];
        
        [newDevice setValue:self.CardNumber.text forKey:@"text1"];
        [newDevice setValue:self.Expiration.text forKey:@"text2"];
        [newDevice setValue:self.Security.text forKey:@"text3"];
         [newDevice setValue:self.BillingCode.text forKey:@"text3"];
    }
    
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"%@ %@", error, [error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
    
    

@end
