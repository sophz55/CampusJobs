//
//  MessageTableViewCell.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/18/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;

- (void)configureCellWithMessage:(Message *)message;

@end
