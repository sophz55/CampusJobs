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
#import "Format.h"
#import <MaterialComponents/MaterialTypography.h>
#import "AppScheme.h"
#import "StringConstants.h"
#import "Card.h"

@implementation MessageCollectionViewCell

- (void)configureCellWithMessage:(Message *)message withConversation:(Conversation *)conversation withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight withViewWidth:(CGFloat)viewWidth{
    self.message = message;
    self.conversation = conversation;
    self.maxWidth = maxWidth;
    self.maxHeight = maxHeight;
    self.viewWidth = viewWidth;
    self.messageTextView.text = message.text;
    
    [self configureCellLayout];
    [self toggleShowSuggestedPriceOptionButtonsView];
}

- (void)configureCellLayout {
    NSString *messageText = self.message.text;
    self.messageTextView.userInteractionEnabled = NO;
    
    if (self.message.isSystemMessage) {
        self.messageTextView.font = [UIFont fontWithName:italicFontName size: 16];
    } else {
        self.messageTextView.font = [UIFont fontWithName:regularFontName size: 16];
    }
    
    // setting frame for message text view
    CGSize boundedSize = CGSizeMake(self.maxWidth, self.maxHeight);
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    CGRect estimatedFrame = [messageText boundingRectWithSize:boundedSize options:options attributes:@{NSFontAttributeName: self.messageTextView.font} context:nil];
    
    NSInteger nextIndex = ([self.conversation.messages indexOfObject:self.message] + 1);
    NSInteger previousIndex = nextIndex - 2;
    
    Message *previousMessage;
    if (previousIndex >= 0) {
        previousMessage = self.conversation.messages[previousIndex];
    }
    CGFloat verticalBubbleInset;
    if (previousIndex < 0 || [previousMessage.sender.objectId isEqualToString:self.message.sender.objectId]) {
        verticalBubbleInset = 4;
    } else {
        verticalBubbleInset = 12;
    }

    CGFloat horizontalTextInset = 8;
    CGFloat verticalTextInset = 8;
    CGFloat horizontalBubbleInset = 4;
    CGSize textViewSize = CGSizeMake(ceil(estimatedFrame.size.width) + 16, ceil(estimatedFrame.size.height));
    CGSize bubbleViewSize = CGSizeMake((textViewSize.width + 2 * horizontalTextInset), (textViewSize.height + 2 * verticalTextInset));
    
    CGFloat imageWidth = 35;
    CGFloat horizontalImageInset = 8;
    CGFloat verticalImageInset = 2;
    
    if (![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        Message *nextMessage;
        if (nextIndex < self.conversation.messages.count) {
            nextMessage = self.conversation.messages[nextIndex];
        }
        if (nextIndex == self.conversation.messages.count || [nextMessage.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
            self.senderProfileImageView.hidden = NO;
            self.senderProfileImageView.frame = CGRectMake(horizontalImageInset, bubbleViewSize.height + verticalBubbleInset - verticalImageInset - imageWidth, imageWidth, imageWidth);
            [Format formatProfilePictureForUser:self.message.sender withView:self.senderProfileImageView];
        } else {
            self.senderProfileImageView.hidden = YES;
        }
        
        CGFloat imageInset = horizontalImageInset + imageWidth;

        self.textBubbleView.frame = CGRectMake(imageInset + horizontalBubbleInset, verticalBubbleInset, bubbleViewSize.width, bubbleViewSize.height);
        self.textBubbleView.backgroundColor = [Colors secondaryGreyLightColor];
        self.textBubbleView.alpha = 0.3;
        self.messageTextView.textColor = [UIColor blackColor];
    } else {
        self.senderProfileImageView.hidden = YES;
        
        self.textBubbleView.frame = CGRectMake(self.viewWidth - bubbleViewSize.width - horizontalBubbleInset, verticalBubbleInset, bubbleViewSize.width, bubbleViewSize.height);
        self.textBubbleView.alpha = 1;
        self.textBubbleView.backgroundColor = [Colors primaryBlueColor];
        self.messageTextView.textColor = [UIColor whiteColor];
    }
    
    self.textBubbleView.layer.cornerRadius = 15;
    self.messageTextView.frame = CGRectMake(self.textBubbleView.frame.origin.x + horizontalTextInset, self.textBubbleView.frame.origin.y + verticalTextInset, textViewSize.width, textViewSize.height);
    
    [Format formatRaisedButton:self.acceptButton];
    [Format formatRaisedButton:self.declineButton];
    UIFont *buttonFont = [UIFont fontWithName:boldFontName size:12];
    [self.acceptButton setTitleFont:buttonFont forState:UIControlStateNormal];
    [self.declineButton setTitleFont:buttonFont forState:UIControlStateNormal];
    [self.acceptButton sizeToFit];
    [self.declineButton sizeToFit];
}

- (void)toggleShowSuggestedPriceOptionButtonsView {
    if (self.conversation.post.postStatus == OPEN && self.message[@"suggestedPrice"] && ![self.message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        
        CGFloat buttonWidth = MAX(self.acceptButton.frame.size.width, self.declineButton.frame.size.width);
        
        CGFloat buttonsViewWidth = 2 * buttonWidth + 8;
        CGFloat buttonsViewOriginX = (self.textBubbleView.frame.size.width - buttonsViewWidth)/2 + self.textBubbleView.frame.origin.x;
        self.suggestedPriceOptionButtonsView.backgroundColor = [UIColor clearColor];
        self.suggestedPriceOptionButtonsView.frame = CGRectMake(buttonsViewOriginX, self.textBubbleView.frame.origin.y + self.textBubbleView.frame.size.height + 5, buttonsViewWidth, 30);
        
        self.acceptButton.frame = CGRectMake(0, 0, buttonWidth, self.suggestedPriceOptionButtonsView.frame.size.height);
        self.declineButton.frame = CGRectMake(self.suggestedPriceOptionButtonsView.frame.size.width - buttonWidth, 0, buttonWidth, self.suggestedPriceOptionButtonsView.frame.size.height);
        [self.suggestedPriceOptionButtonsView setHidden:NO];
    } else {
        [self.suggestedPriceOptionButtonsView setHidden:YES];
    }
}

- (IBAction)didTapAccept:(id)sender {
    [[PFUser currentUser][paymentCard] fetchIfNeededInBackgroundWithBlock:^(PFObject *fetchedCard, NSError *error) {
        if ([[PFUser currentUser][paymentCard] isValidCard]) {
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
        } else {
            [Alert callAlertWithTitle:@"Invalid Payment Card" alertMessage:@"Could not accept job. Please update your payment card info." viewController:self.delegate];
        }
    }];
}

- (IBAction)didTapDecline:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.conversation addToConversationWithSystemMessageWithText:[NSString stringWithFormat:@"%@ declined the price $%d.", [PFUser currentUser].username, self.message.suggestedPrice] withSender:[PFUser currentUser] withReceiver:self.message.sender withCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [weakSelf removeSuggestedPrice];
        } else {
            [Alert callAlertWithTitle:@"Something's wrong." alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:(UIViewController *)weakSelf.delegate];
        }
    }];
}

- (void)removeSuggestedPrice {
    [self.message removeObjectForKey:@"suggestedPrice"];
    [self.message saveInBackgroundWithBlock:^(BOOL saved, NSError *error) {
        if (saved) {
            [self.suggestedPriceOptionButtonsView setHidden:YES];
        } else {
            [Alert callAlertWithTitle:@"Something's wrong." alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:(UIViewController *)self.delegate];
        }
    }];
}

@end
