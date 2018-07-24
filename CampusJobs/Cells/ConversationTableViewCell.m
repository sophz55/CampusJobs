//
//  ConversationTableViewCell.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ConversationTableViewCell.h"

@implementation ConversationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithConversation:(Conversation *)conversation {
    self.conversation = conversation;
    
    self.postTitleLabel.text = conversation.post.title;
    
    if ([[PFUser currentUser].objectId isEqualToString:conversation.post.author.objectId]) {
        self.otherUser = conversation.seeker;
    } else {
        self.otherUser = conversation.post.author;
    }
    self.otherUserLabel.text = self.otherUser.username;
    
    self.messagePreviewLabel.text = [conversation.messages lastObject][@"text"];
}

@end
