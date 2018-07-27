//
//  HomeViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *NameButton;
@property (weak, nonatomic) IBOutlet UIButton *EmailButton;
@property (weak, nonatomic) IBOutlet UIButton *AddressButton;

@property (weak, nonatomic) IBOutlet UIButton *CreditCardButton;
@property (weak, nonatomic) IBOutlet UIButton *RatingButton;

////

- (IBAction)Name:(id)sender;
- (IBAction)Email:(id)sender;
- (IBAction)Address:(id)sender;
- (IBAction)CreditCard:(id)sender;
- (IBAction)Rating:(id)sender;





@end
