//
//  DetailViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/19/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController



{
    
    NSArray *DetailModal;
    
}
@property (weak, nonatomic) IBOutlet UITextField *FirstName;

@property (weak, nonatomic) IBOutlet UITextField *LastName;
@property (weak, nonatomic) IBOutlet UITextField *Username;

@property (weak, nonatomic) IBOutlet UITextField *Password;



@property (weak, nonatomic) IBOutlet UITextField *Address;

@property (strong)NSManagedObjectModel *device;






- (IBAction)SaveData:(id)sender;

- (IBAction)DismissKeyboard:(id)sender;



///////////////

@property (strong, nonatomic) NSArray *DetailModal;


@property (weak, nonatomic) IBOutlet UIImageView *DetailImageView;

@property (weak, nonatomic) IBOutlet UILabel *DetailTitle;

@property (weak, nonatomic) IBOutlet UILabel *DetailDescription;

@property (weak, nonatomic) IBOutlet UILabel *Fullname;

@property (weak, nonatomic) IBOutlet UILabel *Rating;







@end

