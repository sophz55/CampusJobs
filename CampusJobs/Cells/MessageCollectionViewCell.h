//
//  MessageCollectionViewCell.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/23/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
#import "Conversation.h"

@protocol MessageCollectionViewCellDelegate
- (void)reloadData;
@end

@interface MessageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id <MessageCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *textBubbleView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIStackView *buttonsStackView;
@property (strong, nonatomic) Message *message;
@property (strong, nonatomic) Conversation *conversation;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) CGFloat maxHeight;
@property (assign, nonatomic) CGFloat viewWidth;

- (void)configureCellWithMessage:(Message *)message withConversation:(Conversation *)conversation withMaxWidth:(CGFloat)maxWidth withMaxHeight:(CGFloat)maxHeight withViewWidth:(CGFloat)viewWidth;

@end