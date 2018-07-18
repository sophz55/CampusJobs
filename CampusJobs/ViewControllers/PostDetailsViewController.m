//
//  PostDetailsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "Conversation.h"

@interface PostDetailsViewController ()

@property (strong, nonatomic) PFUser *user;

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
}

- (void)messageAuthor {
    Conversation *conversation = [self findConversation];
    NSLog(@"%@", conversation);
}

- (id)findConversation {
    NSMutableArray *conversationsArray = self.user[@"conversations"];
    NSMutableArray *postsArray = [[NSMutableArray alloc] init];
    for (Conversation *conversation in conversationsArray) {
        [postsArray addObject:conversation.post];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author = self.post.author"];
    NSArray *filter = [postsArray filteredArrayUsingPredicate:predicate];
    
    if (filter.count != 0) {
        return filter[0];
    } else {
        Conversation *newConversation = [Conversation new];
        newConversation.messages = [[NSMutableArray alloc] init];
        newConversation.post = self.post;
        newConversation.seeker = self.user;
        return newConversation;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
