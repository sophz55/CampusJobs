//
//  ConversationDetailViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/18/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "ConversationDetailViewController.h"
#import "MessageCollectionViewCell.h"
#import "SuggestPriceViewController.h"
#import "PostDetailsViewController.h"
#import "ConversationsViewController.h"
#import "Message.h"
#import "Helper.h"

@interface ConversationDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, MessageCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *messagesCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) PFUser *user;
@property (assign, nonatomic) CGFloat maxCellWidth;
@property (assign, nonatomic) CGFloat maxCellHeight;
@property (weak, nonatomic) IBOutlet UIButton *suggestPriceButton;
@property (weak, nonatomic) IBOutlet UIView *inProgressOptionsView;
@property (weak, nonatomic) IBOutlet UILabel *jobStatusProgressLabel;
@property (weak, nonatomic) IBOutlet UIButton *jobCompletedButton;
@property (weak, nonatomic) IBOutlet UIStackView *inProgressButtonsStackView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewPostButton;

@end

@implementation ConversationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.user = [PFUser currentUser];
    
    self.messagesCollectionView.delegate = self;
    self.messagesCollectionView.dataSource = self;
    
    self.maxCellWidth = self.messagesCollectionView.frame.size.width * .6; // max message text view width
    self.maxCellHeight = self.messagesCollectionView.frame.size.height * 3; // arbitrary large max message text view height
    
    [self setDefinesPresentationContext:YES];
    [self showByParent];
    [self configureRefreshControl];
    [self configureNavigatonBar];
    [self reloadData];
}

- (void)showByParent {
    if ([self.presentingViewController isKindOfClass:[PostDetailsViewController class]]) {
        self.backButton.title = @"Back to posting";
        [self.viewPostButton setEnabled:NO];
        [self.viewPostButton setTintColor:[UIColor clearColor]];
    } else {
        self.backButton.title = @"Back to messages";
        [self.viewPostButton setEnabled:YES];
        [self.viewPostButton setTintColor:nil];
    }
}

- (IBAction)didTapViewPostButton:(id)sender {
    [self performSegueWithIdentifier:@"messageToPostSegue" sender:nil];
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];
    [self.messagesCollectionView insertSubview:self.refreshControl atIndex:0];
}

- (void)configureNavigatonBar {
    // put other user's username label in navigation bar
    UILabel *otherUserLabel = [[UILabel alloc] init];
    if (![self.conversation.post.title isEqualToString:@""]) {
        otherUserLabel.text = [NSString stringWithFormat:@"%@ - %@", self.otherUser.username, self.conversation.post.title];
    } else {
        otherUserLabel.text = self.otherUser.username;
    }
    self.navigationItem.titleView = otherUserLabel;
}

- (void)reloadData {
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadData) userInfo:nil repeats:YES];
    
    [self.messagesCollectionView reloadData];
    [self configureOptions];
    [self.refreshControl endRefreshing];
}

- (void)configureOptions {
    // show "suggest price" button or "job in progress" bar
    if (self.conversation.post.postStatus == openStatus) {
        [self configureOpenStatusAppearance];
    } else if (self.conversation.post.postStatus == inProgress){
        if ([self.conversation.post.taker.objectId isEqualToString:[PFUser currentUser].objectId]) {
            // if the current user is the post's taker
            [self configureInProgressAppearance];
        } else if ([self.conversation.post.author.objectId isEqualToString:[PFUser currentUser].objectId]){
            if ([self.conversation.post.taker.objectId isEqualToString:self.otherUser.objectId]) {
                // the current user is the post's author, and the other user is the post's taker
                [self configureInProgressAppearance];
            } else {
                // the current user is the post's author, but the other user is not the taker
                [self configureNotTakerAppearance];
            }
        } else {
            // the current user is a seeker but not the taker
            [self configureNotInvolvedUserAppearance];
        }
    } else {
        [self configureFinishedAppearance];
    }
}

- (void)configureOpenStatusAppearance {
    [self.suggestPriceButton setHidden:NO];
    self.suggestPriceButton.frame = CGRectMake(self.suggestPriceButton.frame.origin.x, self.suggestPriceButton.frame.origin.x, 100, self.suggestPriceButton.frame.size.width);
    
    [self.inProgressOptionsView setHidden:YES];
    self.inProgressOptionsView.frame = CGRectMake(self.inProgressOptionsView.frame.origin.x, self.inProgressOptionsView.frame.origin.y, self.inProgressOptionsView.frame.size.width, 0);
}

- (void)configureInProgressAppearance {
    [self.suggestPriceButton setHidden:YES];
    self.suggestPriceButton.frame = CGRectMake(self.suggestPriceButton.frame.origin.x, self.suggestPriceButton.frame.origin.x, 0, self.suggestPriceButton.frame.size.width);
    
    [self.inProgressOptionsView setHidden:NO];
    self.inProgressOptionsView.frame = CGRectMake(self.inProgressOptionsView.frame.origin.x, self.inProgressOptionsView.frame.origin.y, self.inProgressOptionsView.frame.size.width, 70);
    
    [self.inProgressButtonsStackView setHidden:NO];
    
    self.jobStatusProgressLabel.text = [NSString stringWithFormat:@"This job is now in progress for $%@!", self.conversation.post.price];
    
    // show/hide job completed button, since only want post's author to state when job completed
    if ([self.user.objectId isEqualToString:self.conversation.post.author.objectId]) {
        [self.jobCompletedButton setHidden:NO];
    } else {
        [self.jobCompletedButton setHidden:YES];
    }
}

- (void)configureNotInvolvedUserAppearance {
    [self.suggestPriceButton setHidden:YES];
    self.suggestPriceButton.frame = CGRectMake(self.suggestPriceButton.frame.origin.x, self.suggestPriceButton.frame.origin.x, 0, self.suggestPriceButton.frame.size.width);
    
    [self.inProgressButtonsStackView setHidden:YES];
    
    [self.inProgressOptionsView setHidden:NO];
    self.inProgressOptionsView.frame = CGRectMake(self.inProgressOptionsView.frame.origin.x, self.inProgressOptionsView.frame.origin.y, self.inProgressOptionsView.frame.size.width, 30);
    
    self.jobStatusProgressLabel.text = @"Sorry, this job has been taken by another user!";
}

- (void)configureNotTakerAppearance {
    [self.suggestPriceButton setHidden:YES];
    self.suggestPriceButton.frame = CGRectMake(self.suggestPriceButton.frame.origin.x, self.suggestPriceButton.frame.origin.x, 0, self.suggestPriceButton.frame.size.width);
    
    [self.inProgressButtonsStackView setHidden:YES];
    
    [self.inProgressOptionsView setHidden:NO];
    self.inProgressOptionsView.frame = CGRectMake(self.inProgressOptionsView.frame.origin.x, self.inProgressOptionsView.frame.origin.y, self.inProgressOptionsView.frame.size.width, 50);
    self.jobStatusProgressLabel.frame = CGRectMake(self.jobStatusProgressLabel.frame.origin.x, self.jobStatusProgressLabel.frame.origin.y, self.jobStatusProgressLabel.frame.size.width, 50);
    
    self.jobStatusProgressLabel.text = @"This job is already in progress with another user!";
}

- (void)configureFinishedAppearance {
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.conversation.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MessageCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    [cell configureCellWithMessage:self.conversation.messages[indexPath.item] withConversation:self.conversation withMaxWidth:self.maxCellWidth withMaxHeight:self.maxCellHeight withViewWidth:self.messagesCollectionView.frame.size.width];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Message *message = self.conversation.messages[indexPath.item];
    NSString *messageText = message[@"text"];

    // estimate frame size based on message text
    CGSize boundedSize = CGSizeMake(self.maxCellWidth, self.maxCellHeight);
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    CGRect estimatedFrame = [messageText boundingRectWithSize:boundedSize options:options attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    // show/hide the accept/decline suggested price buttons
    CGFloat buttonsStackViewAllowance = 0;
    if (self.conversation.post.postStatus == openStatus && message[@"suggestedPrice"] && ![message.sender.objectId isEqualToString:[PFUser currentUser].objectId]) {
        buttonsStackViewAllowance = 40;
    }

    return CGSizeMake(collectionView.frame.size.width, ceil(estimatedFrame.size.height) + 20 + buttonsStackViewAllowance);
}

- (IBAction)didTapSuggestPriceButton:(id)sender {
    [self setDefinesPresentationContext:YES];
    [self performSegueWithIdentifier:@"suggestPriceModalSegue" sender:nil];
}

- (IBAction)didTapBackButton:(id)sender {
    if (self.conversation.messages.count == 0) {
        [self.conversation deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)didTapAway:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)didTapSendMessage:(id)sender {
    if (![self.messageTextField.text isEqualToString:@""]) {
        __unsafe_unretained typeof(self) weakSelf = self;
        [self.conversation addToConversationWithMessageText:self.messageTextField.text withSender:self.user withReceiver:self.otherUser withCompletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                weakSelf.messageTextField.text = @"";
                [weakSelf.messagesCollectionView reloadData];
            } else {
                [Helper callAlertWithTitle:@"Error sending message" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:weakSelf];
            }
        }];
    }
}

- (IBAction)didTapCancelJobButton:(id)sender {
    [self.conversation.post cancelJobWithCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            __unsafe_unretained typeof(self) weakSelf = self;
            [self.conversation addToConversationWithSystemMessageWithText:[NSString stringWithFormat:@"%@ canceled the job. Please coordinate further to proceed!", [PFUser currentUser].username] withSender:[PFUser currentUser] withReceiver:self.otherUser withCompletion:^(BOOL saved, NSError *error) {
                if (saved) {
                    [weakSelf reloadData];
                } else {
                    [Helper callAlertWithTitle:@"Something's wrong!" alertMessage:[NSString stringWithFormat:@"%@", error] viewController:(UIViewController *)weakSelf];
                }
            }];
        } else {
            [Helper callAlertWithTitle:@"Error Cancelling Job" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (IBAction)didTapJobCompletedButton:(id)sender {
    [self.conversation.post completeJobWithCompletion:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self reloadData];
        } else {
            [Helper callAlertWithTitle:@"Error Registering Job as Complete" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"suggestPriceModalSegue"]) {
        SuggestPriceViewController *suggestPriceController = [segue destinationViewController];
        suggestPriceController.conversation = self.conversation;
        suggestPriceController.otherUser = self.otherUser;
    } else if ([segue.identifier isEqualToString:@"messageToPostSegue"]) {
        PostDetailsViewController *postDetailsVC = [segue destinationViewController];
        postDetailsVC.post = self.conversation.post;
    }
}

@end
