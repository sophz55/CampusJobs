//
//  ConversationDetailViewController.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/18/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Conversation.h"

@interface ConversationDetailViewController : UIViewController

@property (strong, nonatomic) PFUser *otherUser;
@property (strong, nonatomic) Conversation *conversation;

- (void)reloadData;

@end
