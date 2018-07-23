//
//  MessageCollectionViewCell.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTextLabel;

- (void)configureCellWithMessage:(Message *)message;

@end
