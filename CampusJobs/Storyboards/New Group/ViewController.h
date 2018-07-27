//
//  ViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/27/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;


@property(strong, nonatomic) NSString *detail;

@end
