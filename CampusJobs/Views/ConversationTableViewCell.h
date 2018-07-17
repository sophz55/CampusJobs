//
//  ConversationTableViewCell.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Conversation.h"

@interface ConversationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *messagePreviewLabel;
@property (strong, nonatomic) PFUser *otherUser;
@property (strong, nonatomic) Conversation *conversation;

@end
