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
#import "StringConstants.h"
#import <Masonry.h>

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

    if ([[PFUser currentUser].objectId isEqualToString:conversation.post.author.objectId]) {
        self.otherUser = conversation.seeker;
    } else {
        self.otherUser = conversation.post.author;
    }
    self.otherUserLabel.text = self.otherUser.username;
    self.otherUserLabel.font = [UIFont fontWithName:regularFontName size:18];
    
    [Format formatProfilePictureForUser:self.otherUser withView:self.otherUserProfileImageView];
    
    self.postTitleLabel.text = [conversation.post.title uppercaseString];
    if ([conversation.post.title isEqualToString:@""]) {
        self.postTitleLabel.text = @"UNTITLED POST";
    }
    self.postTitleLabel.font = [UIFont fontWithName:boldFontName size:18];
    
    Message *lastMessage = [conversation.messages lastObject];
    
    if (lastMessage.isSystemMessage) {
        self.messagePreviewLabel.font = [UIFont fontWithName:lightItalicFontName size: 16];
    } else {
        self.messagePreviewLabel.font = [UIFont fontWithName:lightFontName size: 16];
    }

    self.messagePreviewLabel.text = lastMessage[@"text"];
    
    if (self.conversation.post.postStatus == OPEN) {
        self.statusLabel.text = @"OPEN";
    } else if ([[PFUser currentUser].objectId isEqualToString:self.conversation.post.author.objectId]) {
        if ([self.otherUser.objectId isEqualToString:self.conversation.post.taker.objectId]) {
            if (self.conversation.post.postStatus == IN_PROGRESS) {
                self.statusLabel.text = @"IN PROGRESS";
            } else {
                self.statusLabel.text = @"COMPLETED";
            }
        } else {
            if (self.conversation.post.postStatus == IN_PROGRESS) {
                self.statusLabel.text = @"ACTIVE WITH ANOTHER USER";
            } else {
                self.statusLabel.text = @"COMPLETED BY ANOTHER USER";
            }
        }
    } else if ([[PFUser currentUser].objectId isEqualToString:self.conversation.post.taker.objectId]) {
        if (self.conversation.post.postStatus == IN_PROGRESS) {
            self.statusLabel.text = @"IN PROGRESS";
        } else {
            self.statusLabel.text = @"COMPLETED";
        }
    } else {
        self.statusLabel.text = @"TAKEN BY ANOTHER USER";
    }
    
    self.statusLabel.backgroundColor = [UIColor whiteColor];
    self.statusLabel.layer.cornerRadius = 5;
    self.statusLabel.clipsToBounds = YES;
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.layer.borderColor = [[Colors primaryOrangeColor] CGColor];
    self.statusLabel.font = [UIFont fontWithName:boldFontName size:12];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.statusLabel sizeToFit];
    
    [self configureLayout];
}

- (void)configureLayout {
    [self.otherUserProfileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@8);
        make.left.equalTo(@8);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.otherUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherUserProfileImageView.mas_top);
        make.left.equalTo(self.otherUserProfileImageView.mas_right).with.offset(10);
    }];
    
    [self.postTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.otherUserLabel.mas_top);
        make.left.equalTo(self.otherUserLabel.mas_right).with.offset(10);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.statusLabel removeConstraints:self.statusLabel.constraints];
        make.top.equalTo(self.otherUserLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.otherUserLabel.mas_left);
        make.width.equalTo(@(self.statusLabel.frame.size.width + 20));
        make.height.equalTo(@(self.statusLabel.frame.size.height + 4));
    }];
    
    [self.messagePreviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).with.offset(2);
        make.left.equalTo(self.statusLabel.mas_left);
        make.width.lessThanOrEqualTo(@275);
    }];
}

@end
