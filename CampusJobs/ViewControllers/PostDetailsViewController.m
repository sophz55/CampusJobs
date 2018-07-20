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

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    [self setDetailsPost:self.post];
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
    self.locationDetailsLabel.text=post.location;
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
                NSLog(@"Found Existing Conversation");
            }
            // if there are no conversations with these users and this post, create one
            else {
                self.conversation = [Conversation createNewConversationWithPost:self.post withSeeker:self.user withCompletion:^(BOOL succeeded, NSError * _Nullable error){
                    if(succeeded){
                        NSLog(@"New Conversation Created Successfully");
                    } else{
                        [Helper callAlertWithTitle:@"Error Creating Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
                    }
                }];
            }
            
            [self performSegueWithIdentifier:@"chatSegue" sender:nil];
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
