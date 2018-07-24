//
//  MessageCollectionViewCell.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "MessageCollectionViewCell.h"
#import "Helper.h"
#import "ConversationDetailViewController.h"

@implementation MessageCollectionViewCell

- (void)configureCellWithMessage:(Message *)message withConversation:(Conversation *)conversation withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight{
    self.message = message;
    self.conversation = conversation;
    self.maxWidth = maxWidth;
    self.maxHeight = maxHeight;
    self.messageTextView.text = message.text;
    [self configureCellLayout];
    [self toggleButtonStackView];
}

- (void)configureCellLayout {
    NSString *messageText = self.message.text;
    
    // setting frame for message text view
    CGSize boundedSize = CGSizeMake(self.maxWidth * .6, self.maxHeight);
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    CGRect estimatedFrame = [messageText boundingRectWithSize:boundedSize options:options attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];

    CGFloat textInset = 8;
    CGFloat bubbleInset = 4;
    CGRect frame = CGRectMake(textInset + bubbleInset, 0, estimatedFrame.size.width + 16, estimatedFrame.size.height + 20);
    self.messageTextView.frame = frame;
    
    self.textBubbleView.frame = CGRectMake(frame.origin.x - textInset + bubbleInset, frame.origin.y, frame.size.width + textInset, frame.size.height);
    self.textBubbleView.layer.cornerRadius = 10;
    self.textBubbleView.backgroundColor = [UIColor lightGrayColor];
    self.textBubbleView.alpha = 0.3;
    
    if ([self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.messageTextView.frame = CGRectMake(self.maxWidth - frame.size.width - bubbleInset, frame.origin.y, frame.size.width, frame.size.height);
        
        self.textBubbleView.frame = CGRectMake(self.maxWidth - frame.size.width - textInset - bubbleInset, frame.origin.y, frame.size.width + textInset, frame.size.height);
        self.textBubbleView.backgroundColor = [UIColor colorWithRed:0.00 green:0.30 blue:1.00 alpha:1.00];
    }
}

- (void)toggleButtonStackView {
    if (self.message[@"suggestedPrice"] && ![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.buttonsStackView.frame = CGRectMake(self.textBubbleView.frame.origin.x + self.textBubbleView.frame.size.width * .1, self.textBubbleView.frame.origin.y+self.textBubbleView.frame.size.height + 5, self.textBubbleView.frame.size.width * .8, 30);
        [self.buttonsStackView setHidden:NO];
    }
}

- (IBAction)didTapAccept:(id)sender {
    [Message createMessageWithText:[NSString stringWithFormat:@"%@ accepted the price $%d", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            [self.message removeObjectForKey:@"suggestedPrice"];
            [self.buttonsStackView setHidden:YES];
            [self.conversation addToConversationWithMessage:(Message *)createdMessage withCompletion:^(BOOL succeeded, NSError *error) {}];
        } else {}
    }];
}

- (IBAction)didTapDecline:(id)sender {
    [Message createMessageWithText:[NSString stringWithFormat:@"%@ declined the price $%d", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            [self.message removeObjectForKey:@"suggestedPrice"];
            [self.buttonsStackView setHidden:YES];
            [self.conversation addToConversationWithMessage:(Message *)createdMessage withCompletion:^(BOOL succeeded, NSError *error) {}];
        } else {}
    }];
}

@end
