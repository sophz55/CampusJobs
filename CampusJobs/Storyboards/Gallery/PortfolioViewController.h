//
//  PortfolioViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortfolioViewController : UIViewController

{
    
    int imageInt;
    
}





@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;


@end
