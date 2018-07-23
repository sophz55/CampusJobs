//
//  SuggestPriceViewController.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/20/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversation.h"
#import <Parse/Parse.h>

@interface SuggestPriceViewController : UIViewController

@property (strong, nonatomic) Conversation *conversation;
@property (strong, nonatomic) PFUser *otherUser;

@end
