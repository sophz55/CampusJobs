//
//  ViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController



@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;

- (IBAction)Name:(id)sender;
- (IBAction)Gallery:(id)sender;
- (IBAction)Bio:(id)sender;
- (IBAction)Rating:(id)sender;


@end
