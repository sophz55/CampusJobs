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
#import "Helper.h"

@interface PostDetailsViewController ()

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Conversation *conversation;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    [self setDetailsPost:self.post];
    [self setDefinesPresentationContext:YES];
}

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapMessageButton:(id)sender {
    [self findConversation];
}

-(void) setDetailsPost:(Post *)post{
    self.titleDetailsLabel.text=post.title;
    self.descriptionDetailsLabel.text=post.summary;
    self.userDetailsLabel.text=post.author.username;
}

- (void)findConversation {
    
    // create query to access "author" key within a conversation's post
    PFQuery *postsQuery = [PFQuery queryWithClassName:@"Post"];
    [postsQuery whereKey:@"author" equalTo:self.post.author];
    
    // create query for conversations with current user as seeker, post author as author, post as post
    PFQuery *conversationsQuery=[PFQuery queryWithClassName:@"Conversation"];
    [conversationsQuery includeKey:@"post"];
    [conversationsQuery whereKey:@"post" matchesQuery:postsQuery];
    [conversationsQuery whereKey:@"post" equalTo:self.post];
    
    [conversationsQuery includeKey: @"seeker"];
    [conversationsQuery whereKey:@"seeker" equalTo:self.user];
    
    [conversationsQuery includeKey: @"messages"];
    
    [conversationsQuery findObjectsInBackgroundWithBlock:^(NSArray *conversations, NSError*error){
        if (error != nil) {
            [Helper callAlertWithTitle:@"Could not open conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        } else {
            if (conversations.count > 0) {
                self.conversation = conversations[0];
                [self performSegueWithIdentifier:@"chatSegue" sender:nil];
            }
            // if there are no conversations with these users and this post, create one
            else {
                [Conversation createNewConversationWithPost:self.post withSeeker:self.user withCompletion:^(PFObject *newConversation, NSError * _Nullable error){
                    if (newConversation){
                        self.conversation = (Conversation *)newConversation;
                        [self performSegueWithIdentifier:@"chatSegue" sender:nil];
                    } else{
                        [Helper callAlertWithTitle:@"Error Creating Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
                    }
                }];
            }
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
        UINavigationController *conversationNavigationController = [segue destinationViewController];
        ConversationDetailViewController *conversationDetailController = [conversationNavigationController topViewController];
        conversationDetailController.conversation = self.conversation;
        conversationDetailController.otherUser = self.post.author;
    }
}


@end
