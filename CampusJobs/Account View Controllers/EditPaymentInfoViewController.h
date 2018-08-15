//
//  EditPaymentInfoViewController.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditPaymentDelegate
@end

@interface EditPaymentInfoViewController : UIViewController

@property (strong, nonatomic) UIViewController <EditPaymentDelegate> *delegate;

@end
