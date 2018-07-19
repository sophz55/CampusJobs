//
//  PostDetailsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "ConversationDetailViewController.h"
#import "Conversation.h"

@interface PostDetailsViewController ()

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Conversation *conversation;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [PFUser currentUser];
    
}
- (IBAction)didTapBackButton:(id)sender {
    [self performSegueWithIdentifier:@"backToNearbyFeedSegue" sender:nil];
}

- (IBAction)didTapMessageButton:(id)sender {
    [self findConversation];
    [self performSegueWithIdentifier:@"chatSegue" sender:nil];
}

- (void)findConversation {
    // create pfquery for conversations with current user as seeker, post author as author
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"post.author = %@", self.post.author];
    PFQuery *conversationsQuery=[PFQuery queryWithClassName:@"Conversation" predicate:predicate];
    [conversationsQuery includeKey:@"post"];
    [conversationsQuery includeKey: @"seeker"];
    [conversationsQuery includeKey: @"messages"];
    [conversationsQuery whereKey:@"seeker" equalTo:self.user];
    [conversationsQuery findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError*error){
        if (conversations != nil) {
            // look through all conversations with correct user roles to see if exists conversation containing specific post in question
            BOOL hasExistingConversation = NO;
            int i = 0;
            while (!hasExistingConversation && i < conversations.count) {
                if (conversations[i][@"post"] == self.post) {
                    hasExistingConversation = YES;
                    NSLog(@"Found Existing Conversation");
                    self.conversation = conversations[i];
                }
                i += 1;
            }
            
            // if there are no conversations with these users and this post, create one
            if (!hasExistingConversation) {
                self.conversation = [Conversation createNewConversationWithPost:self.post withSeeker:self.user withCompletion:^(BOOL succeeded, NSError * _Nullable error){
                    if(succeeded){
                        NSLog(@"New Conversation Created Successfully");
                    } else{
                        NSLog(@"%@", error.localizedDescription);
                    }
                }];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
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
    if ([segue.identifier isEqualToString:@"chatSegue"]) {
        ConversationDetailViewController *conversationDetailController = [segue destinationViewController];
        conversationDetailController.conversation = self.conversation;
        conversationDetailController.otherUser = self.post.author;
    }
}


@end
