//
//  MessageCollectionViewCell.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "MessageCollectionViewCell.h"

@implementation MessageCollectionViewCell

- (void)configureCellWithMessage:(Message *)message {
    self.messageTextLabel.text = message.text;
}

@end
