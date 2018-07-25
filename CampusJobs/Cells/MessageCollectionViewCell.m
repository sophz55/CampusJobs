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
    if (message.isSystemMessage) {
        self.messageTextView.font = [UIFont italicSystemFontOfSize:16.0f];
    } else {
        self.messageTextView.font = [UIFont systemFontOfSize:16.0f];
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

    CGFloat textHorizontalInset = 8;
    CGFloat textVerticalInset = 4;
    CGFloat bubbleInset = 4;
    CGSize textViewSize = CGSizeMake(ceil(estimatedFrame.size.width) + 16, ceil(estimatedFrame.size.height) + 8);
    CGSize paddedSize = CGSizeMake(textViewSize.width + textHorizontalInset, textViewSize.height + 3 * textVerticalInset);
    
    if (![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.textBubbleView.frame = CGRectMake(bubbleInset, bubbleInset, paddedSize.width, paddedSize.height);
        self.textBubbleView.backgroundColor = [UIColor lightGrayColor];
        self.textBubbleView.alpha = 0.3;
        self.messageTextView.textColor = [UIColor blackColor];
    } else {
        self.textBubbleView.frame = CGRectMake(self.viewWidth - paddedSize.width - bubbleInset, bubbleInset, paddedSize.width, paddedSize.height);
        self.textBubbleView.alpha = 1;
        self.textBubbleView.backgroundColor = [UIColor colorWithRed:0.00 green:0.50 blue:1.00 alpha:1.00];
        self.messageTextView.textColor = [UIColor whiteColor];
    }
    
    self.textBubbleView.layer.cornerRadius = 15;
    self.messageTextView.frame = CGRectMake(self.textBubbleView.frame.origin.x + textHorizontalInset, self.textBubbleView.frame.origin.y + textVerticalInset, textViewSize.width, textViewSize.height);
}

- (void)toggleShowButtonStackView {
    if (self.conversation.post.postStatus == openStatus && self.message[@"suggestedPrice"] && ![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.buttonsStackView.frame = CGRectMake(self.textBubbleView.frame.origin.x + self.textBubbleView.frame.size.width * .1, self.textBubbleView.frame.origin.y + self.textBubbleView.frame.size.height + 5, self.textBubbleView.frame.size.width * .8, 30);
        [self.buttonsStackView setHidden:NO];
    }
}

- (IBAction)didTapAccept:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.conversation addToConversationWithMessageText:[NSString stringWithFormat:@"%@ accepted the price $%d. This job is now in progress - please coordinate how you would like to proceed!", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFUser *taker = weakSelf.message.sender;
            if ([weakSelf.message.sender.objectId isEqualToString:weakSelf.conversation.post.author.objectId]) {
                taker = weakSelf.message.receiver;
            }
            [weakSelf.conversation.post acceptJobWithPrice:[NSNumber numberWithInt:weakSelf.message.suggestedPrice] withTaker:taker withCompletion:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"%d", weakSelf.message.suggestedPrice);
                    [weakSelf removeSuggestedPrice];
                    [weakSelf.delegate reloadData];
                } else {
                    [Helper callAlertWithTitle:@"Error Accepting Job" alertMessage:[NSString stringWithFormat:@"%@", error] viewController:(UIViewController *)weakSelf.delegate];
                }
            }];
        } else {
            [Helper callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error] viewController:(UIViewController *)weakSelf.delegate];
        }
    }];
}

- (IBAction)didTapDecline:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.conversation addToConversationWithMessageText:[NSString stringWithFormat:@"%@ declined the price $%d.", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [weakSelf removeSuggestedPrice];
        } else {
            [Helper callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error] viewController:(UIViewController *)weakSelf.delegate];
        }
    }];
}

- (void)removeSuggestedPrice {
    [self.message removeObjectForKey:@"suggestedPrice"];
    [self.message saveInBackgroundWithBlock:^(BOOL saved, NSError *error) {
        if (saved) {
            [self.buttonsStackView setHidden:YES];
        } else {
            [Helper callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error] viewController:(UIViewController *)self.delegate];
        }
    }];
}

@end
