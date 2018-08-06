//
//  MessageCollectionViewCell.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "MessageCollectionViewCell.h"
#import "Alert.h"
#import "ConversationDetailViewController.h"
#import "Colors.h"

@implementation MessageCollectionViewCell

- (void)configureCellWithMessage:(Message *)message withConversation:(Conversation *)conversation withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight withViewWidth:(CGFloat)viewWidth{
    self.message = message;
    self.conversation = conversation;
    self.maxWidth = maxWidth;
    self.maxHeight = maxHeight;
    self.viewWidth = viewWidth;
    self.messageTextView.text = message.text;
    if (message.isSystemMessage) {
        self.messageTextView.font = [UIFont italicSystemFontOfSize:16];
    } else {
        self.messageTextView.font = [UIFont systemFontOfSize:16];
    }
    [self configureCellLayout];
    [self toggleShowButtonStackView];
}

- (void)configureCellLayout {
    NSString *messageText = self.message.text;
    self.messageTextView.userInteractionEnabled = NO;
    
    // setting frame for message text view
    CGSize boundedSize = CGSizeMake(self.maxWidth, self.maxHeight);
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    CGRect estimatedFrame = [messageText boundingRectWithSize:boundedSize options:options attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    CGFloat horizontalTextInset = 8;
    CGFloat verticalTextInset = 8;
    CGFloat horizontalBubbleInset = 4;
    CGFloat verticalBubbleInset = 4;
    CGSize textViewSize = CGSizeMake(ceil(estimatedFrame.size.width) + 16, ceil(estimatedFrame.size.height));
    CGSize bubbleViewSize = CGSizeMake((textViewSize.width + 2 * horizontalTextInset), (textViewSize.height + 2 * verticalTextInset));
    
    if (![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.textBubbleView.frame = CGRectMake(horizontalBubbleInset, verticalBubbleInset, bubbleViewSize.width, bubbleViewSize.height);
        self.textBubbleView.backgroundColor = [Colors secondaryGreyLightColor];
        self.textBubbleView.alpha = 0.3;
        self.messageTextView.textColor = [UIColor blackColor];
    } else {
        self.textBubbleView.frame = CGRectMake(self.viewWidth - bubbleViewSize.width - horizontalBubbleInset, verticalBubbleInset, bubbleViewSize.width, bubbleViewSize.height);
        self.textBubbleView.alpha = 1;
        self.textBubbleView.backgroundColor = [UIColor colorWithRed:0.00 green:0.50 blue:1.00 alpha:1.00];
        self.messageTextView.textColor = [UIColor whiteColor];
    }
    
    self.textBubbleView.layer.cornerRadius = 15;
    self.messageTextView.frame = CGRectMake(self.textBubbleView.frame.origin.x + horizontalTextInset, self.textBubbleView.frame.origin.y + verticalTextInset, textViewSize.width, textViewSize.height);
}

- (void)toggleShowButtonStackView {
    if (self.conversation.post.postStatus == OPEN && self.message[@"suggestedPrice"] && ![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.buttonsStackView.frame = CGRectMake(self.textBubbleView.frame.origin.x + self.textBubbleView.frame.size.width * .1, self.textBubbleView.frame.origin.y + self.textBubbleView.frame.size.height + 5, self.textBubbleView.frame.size.width * .8, 30);
        [self.buttonsStackView setHidden:NO];
    } else {
        [self.buttonsStackView setHidden:YES];
    }
}

- (IBAction)didTapAccept:(id)sender {
    PFUser *taker;
    if ([self.message.sender.objectId isEqualToString:self.conversation.post.author.objectId]) {
        taker = self.message.receiver;
    } else {
        taker = self.message.sender;
    }
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [weakSelf.conversation.post acceptJobWithPrice:[NSNumber numberWithInt:weakSelf.message.suggestedPrice] withTaker:taker withConversation:self.conversation withCompletion:^(BOOL didUpdateJob, NSError *error) {
        if (didUpdateJob) {
            [weakSelf removeSuggestedPrice];
            [weakSelf.delegate reloadData];
        } else {
            [Alert callAlertWithTitle:@"Error Accepting Job" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:(UIViewController *)weakSelf.delegate];
        }
    }];
}

- (IBAction)didTapDecline:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.conversation addToConversationWithSystemMessageWithText:[NSString stringWithFormat:@"%@ declined the price $%d.", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [weakSelf removeSuggestedPrice];
        } else {
            [Alert callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:(UIViewController *)weakSelf.delegate];
        }
    }];
}

- (void)removeSuggestedPrice {
    [self.message removeObjectForKey:@"suggestedPrice"];
    [self.message saveInBackgroundWithBlock:^(BOOL saved, NSError *error) {
        if (saved) {
            [self.buttonsStackView setHidden:YES];
        } else {
            [Alert callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:(UIViewController *)self.delegate];
        }
    }];
}

@end
