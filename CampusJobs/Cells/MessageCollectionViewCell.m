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

- (void)configureCellWithMessage:(Message *)message withConversation:(Conversation *)conversation withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight withViewWidth:(CGFloat)viewWidth{
    self.message = message;
    self.conversation = conversation;
    self.maxWidth = maxWidth;
    self.maxHeight = maxHeight;
    self.viewWidth = viewWidth;
    self.messageTextView.text = message.text;
    [self configureCellLayout];
    [self toggleShowButtonStackView];
}

- (void)configureCellLayout {
    NSString *messageText = self.message.text;
    self.messageTextView.userInteractionEnabled = NO;
    
    // setting frame for message text view
    CGSize boundedSize = CGSizeMake(self.maxWidth, self.maxHeight);
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    CGRect estimatedFrame = [messageText boundingRectWithSize:boundedSize options:options attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];

    CGFloat textHorizontalInset = 6;
    CGFloat textVerticalInset = 4;
    CGFloat bubbleInset = 4;
    CGSize textViewSize = CGSizeMake(estimatedFrame.size.width + 6, estimatedFrame.size.height + 4);
    CGSize paddedSize = CGSizeMake(textViewSize.width + textHorizontalInset, textViewSize.height + 2 * textVerticalInset);
    
    if (![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.textBubbleView.frame = CGRectMake(bubbleInset, bubbleInset, paddedSize.width, paddedSize.height);
        self.textBubbleView.backgroundColor = [UIColor lightGrayColor];
        self.textBubbleView.alpha = 0.3;
    } else {
        self.textBubbleView.frame = CGRectMake(self.viewWidth - paddedSize.width - bubbleInset, bubbleInset, paddedSize.width, paddedSize.height);
        self.textBubbleView.backgroundColor = [UIColor colorWithRed:0.00 green:0.30 blue:1.00 alpha:0.60];
    }
    
    self.textBubbleView.layer.cornerRadius = 12;
    self.messageTextView.frame = CGRectMake(self.textBubbleView.frame.origin.x + textHorizontalInset, self.textBubbleView.frame.origin.y, textViewSize.width, textViewSize.height);
}

- (void)toggleShowButtonStackView {
    if (self.message[@"suggestedPrice"] && ![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.buttonsStackView.frame = CGRectMake(self.textBubbleView.frame.origin.x + self.textBubbleView.frame.size.width * .1, self.textBubbleView.frame.origin.y+self.textBubbleView.frame.size.height + 5, self.textBubbleView.frame.size.width * .8, 30);
        [self.buttonsStackView setHidden:NO];
    }
}

- (IBAction)didTapAccept:(id)sender {
    [Message createMessageWithText:[NSString stringWithFormat:@"%@ accepted the price $%d. This job is now in progress - please coordinate how you would like to proceed!", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            __unsafe_unretained typeof(self) weakSelf = self;
            [self.message removeObjectForKey:@"suggestedPrice"];
            [self.buttonsStackView setHidden:YES];
            [self.conversation addToConversationWithMessage:(Message *)createdMessage withCompletion:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    Post *post = weakSelf.conversation.post;
                    post.postStatus = inProgress;
                    post.price = [NSNumber numberWithInt:weakSelf.message.suggestedPrice];
                    post.taker = [PFUser currentUser];
                    [weakSelf.delegate toggleOptionsShown];
                    [weakSelf.delegate reloadData];
                } else {
                    [Helper callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error] viewController:(UIViewController *)weakSelf.delegate];
                }
            }];
        } else {
            [Helper callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error] viewController:(UIViewController *)self.delegate];
        }
    }];
}

- (IBAction)didTapDecline:(id)sender {
    [Message createMessageWithText:[NSString stringWithFormat:@"%@ declined the price $%d.", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(PFObject *createdMessage, NSError *error) {
        if (createdMessage) {
            [self.message removeObjectForKey:@"suggestedPrice"];
            [self.buttonsStackView setHidden:YES];
            [self.conversation addToConversationWithMessage:(Message *)createdMessage withCompletion:^(BOOL succeeded, NSError *error) {}];
        } else {}
    }];
}

@end
