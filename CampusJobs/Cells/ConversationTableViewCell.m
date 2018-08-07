//
//  ConversationTableViewCell.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/17/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ConversationTableViewCell.h"
#import "Colors.h"
#import "Format.h"
#import "AppScheme.h"
#import <MaterialComponents/MaterialTypography.h>

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
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    self.conversation = conversation;

    if ([[PFUser currentUser].objectId isEqualToString:conversation.post.author.objectId]) {
        self.otherUser = conversation.seeker;
    } else {
        self.otherUser = conversation.post.author;
    }
    self.otherUserLabel.text = self.otherUser.username;
    self.otherUserLabel.font = typographyScheme.headline6;
    
    [Format formatProfilePictureForUser:self.otherUser withView:self.otherUserProfileImageView];
    
    self.postTitleLabel.text = [conversation.post.title uppercaseString];
    self.postTitleLabel.font = typographyScheme.overline;
    
    Message *lastMessage = [conversation.messages lastObject];
    
    if (lastMessage.isSystemMessage) {
        self.messagePreviewLabel.font = [UIFont fontWithName:@"RobotoCondensed-LightItalic" size: 16];
    } else {
        self.messagePreviewLabel.font = typographyScheme.subtitle1;
    }

    self.messagePreviewLabel.text = lastMessage[@"text"];
}

@end
