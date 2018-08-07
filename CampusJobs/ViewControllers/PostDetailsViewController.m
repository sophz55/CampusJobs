//
//  PostDetailsViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "PostDetailsViewController.h"

#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialAppBar.h>
#import <ChameleonFramework/Chameleon.h>

#import "AppScheme.h"
#import "Alert.h"
#import "Utils.h"
#import "SegueConstants.h"
#import "Format.h"

#import "ConversationDetailViewController.h"
#import "Conversation.h"
#import "MapDetailsViewController.h"
#import "ComposeNewPostViewController.h"

@interface PostDetailsViewController () <ComposePostDelegate, ConversationDetailDelegate, AlertDelegate> {
    CLLocationCoordinate2D geoPointToCoord;
}

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Conversation *conversation;
@property (assign, nonatomic) BOOL userIsAuthor;

@property (strong, nonatomic) MDCAppBar *appBar;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *editButton;

@property (weak, nonatomic) IBOutlet MDCRaisedButton *messageButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *deleteButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *cancelButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *viewLocationButton;

@property (weak, nonatomic) IBOutlet UILabel *titleDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *userDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionDetailsLabel;
@property (weak, nonatomic) IBOutlet MKMapView *postLocationMap;

@end

@implementation PostDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    self.userIsAuthor = [self.post.author.objectId isEqualToString:self.user.objectId];
    [self configureInitialView];
    [self setMapWithAnnotation];
    self.view.backgroundColor=[Colors secondaryGreyLighterColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate Methods

- (void)reloadDetails {
    [self setDetailsPost:self.post];
    [self configureInitialView];
}

- (void)confirmationAlertHandler:(BOOL)response {
    if (response) {
        if (self.post.postStatus == OPEN && self.userIsAuthor) {
            [self deletePost];
        } else if (self.post.postStatus == IN_PROGRESS) {
            [self cancelJob];
        }
    }
}

#pragma mark - Custom Configurations

- (void)formatColors{
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    self.titleDetailsLabel.textColor = colorScheme.onSurfaceColor;
    self.userDetailsLabel.textColor = colorScheme.onSurfaceColor;
    self.locationDetailsLabel.textColor = colorScheme.onSurfaceColor;
    self.descriptionDetailsLabel.textColor = colorScheme.onSurfaceColor;
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:self.messageButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:self.deleteButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:self.cancelButton];
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:self.viewLocationButton];
    self.viewLocationButton.backgroundColor = colorScheme.secondaryColor;
    self.viewLocationButton.tintColor = colorScheme.onSecondaryColor;
}

- (void)configureInitialView {
    [self configureNavigatonBar];
    [self formatColors];
    
    [self setDetailsPost:self.post];
    
    if (self.userIsAuthor) {
        [self configureAuthorView];
    } else {
        [self configureSeekerView];
    }
    
    if (self.post.postStatus == IN_PROGRESS && (self.userIsAuthor || [self.user.objectId isEqualToString:self.post.taker.objectId])) {
        self.cancelButton.hidden = NO;
    } else {
        self.cancelButton.hidden = YES;
    }
    
    [Format formatRaisedButton:self.cancelButton];
    [Format centerHorizontalView:self.cancelButton inView:self.view];
    
    [Format formatRaisedButton:self.messageButton];
    [Format centerHorizontalView:self.messageButton inView:self.view];
    
    [Format formatRaisedButton:self.deleteButton];
    [Format centerHorizontalView:self.deleteButton inView:self.view];
    
}

- (void)configureNavigatonBar {
    
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton:)];
    self.navigationItem.leftBarButtonItem = self.backButton;
    
    self.editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(didTapEditButton:)];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    NSString *title;
    if (self.userIsAuthor) {
        title = @"Your Posting";
    } else {
        title = [NSString stringWithFormat:@"%@'s Posting", self.post.author.username];
    }
    
    [Format formatAppBar:self.appBar withTitle:title];
}

- (void)configureAuthorView {
    [self.editButton setEnabled:YES];
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    if (self.post.postStatus == OPEN) {
        self.userDetailsLabel.text = [NSString stringWithFormat: @"Open Post"];
        self.deleteButton.hidden = NO;
    } else if (self.post.postStatus == IN_PROGRESS) {
        self.userDetailsLabel.text = [NSString stringWithFormat: @"In progress with user: %@", self.post.taker.username];
        self.deleteButton.hidden = YES;
    } else {
        self.userDetailsLabel.text = [NSString stringWithFormat: @"Completed by: %@", self.post.taker.username];
        self.deleteButton.hidden = YES;
    }
    
    if ([self.delegate isKindOfClass:[ConversationDetailViewController class]] || self.post.postStatus == OPEN) {
        self.messageButton.hidden = YES;
    } else {
        self.messageButton.hidden = NO;
        [self.messageButton setTitle:[NSString stringWithFormat: @"Message %@", self.post.taker.username] forState:UIControlStateNormal];
    }
}

- (void)configureSeekerView {
    if ([self.delegate isKindOfClass:[ConversationDetailViewController class]]) {
        self.messageButton.hidden = YES;
    } else {
        self.messageButton.hidden = NO;
        [self.messageButton setTitle:@"Message" forState:UIControlStateNormal];
    }
    
    [self.editButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = nil;
    self.deleteButton.hidden = YES;
    
    self.userDetailsLabel.text = [NSString stringWithFormat: @"%@", self.post.author.username];
}

- (void)setDetailsPost:(Post *)post{
    //set fonts
    self.titleDetailsLabel.font=[UIFont fontWithName:@"RobotoCondensed-Regular" size:24];
    self.descriptionDetailsLabel.font=[UIFont fontWithName:@"RobotoCondensed-LightItalic" size: 18];
    self.locationDetailsLabel.font=[UIFont fontWithName:@"RobotoCondensed-Regular" size:18];
    self.userDetailsLabel.font=[UIFont fontWithName:@"RobotoCondensed-Light" size:24];
    
    //set color
    self.titleDetailsLabel.textColor=[UIColor blackColor];
    self.locationDetailsLabel.textColor=[UIColor blackColor];
    self.userDetailsLabel.textColor=[UIColor blackColor];
    self.descriptionDetailsLabel.textColor=[UIColor blackColor];
    
    //set text
    self.titleDetailsLabel.text=[post.title uppercaseString];
    self.descriptionDetailsLabel.text=post.summary;
    [self.descriptionDetailsLabel sizeToFit];
    self.locationDetailsLabel.text=post.locationAddress;
}

#pragma mark - IBAction

- (IBAction)didTapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapMessageButton:(id)sender {
    if (!self.userIsAuthor) {
        [self findConversation];
    } else {
        [self findConversationWithTaker];
    }
}

- (IBAction)didTapEditButton:(id)sender {
    if (self.userIsAuthor) {
        [self performSegueWithIdentifier:postDetailsToEditPostSegue sender:nil];
    }
}

- (IBAction)didTapDeleteButton:(id)sender {
    if (self.userIsAuthor && self.post.postStatus == OPEN) {
        [Alert callConfirmationWithTitle:@"Are you sure you want to delete this post?" confirmationMessage:@"This cannot be undone." yesActionTitle:@"Delete" noActionTitle:@"Cancel" viewController:self];
    }
}

- (IBAction)didTapCancelButton:(id)sender {
    if (self.post.postStatus == IN_PROGRESS && (self.userIsAuthor || [self.user.objectId isEqualToString:self.post.taker.objectId])) {
        NSString *confirmationMessage;
        if (self.userIsAuthor) {
            confirmationMessage = [NSString stringWithFormat:@"It is currently in progress with %@ for $%@.", self.post.taker.username, self.post.price];
        } else {
            confirmationMessage = [NSString stringWithFormat:@"It is currently in progress for %@.", self.post.price];
        }
        [Alert callConfirmationWithTitle:@"Are you sure you want to cancel this job?" confirmationMessage:confirmationMessage yesActionTitle:@"Cancel job" noActionTitle:@"No, go back" viewController:self];
    }
}

#pragma mark - Private Methods
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
    
    [conversationsQuery getFirstObjectInBackgroundWithBlock:^(NSObject *conversation, NSError*error){
        if (conversation) {
            self.conversation = (Conversation *)conversation;
            [self performSegueWithIdentifier:postDetailsToMessageSegue sender:nil];
        } else if (error.code == 101) { // if there are no conversations with these users and this post, create one
            [Conversation createNewConversationWithPost:self.post withSeeker:self.user withCompletion:^(PFObject *newConversation, NSError * _Nullable error){
                if (newConversation){
                    self.conversation = (Conversation *)newConversation;
                    [self performSegueWithIdentifier:postDetailsToMessageSegue sender:nil];
                } else {
                    [Alert callAlertWithTitle:@"Error Creating Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
                }
            }];
        } else {
            [Alert callAlertWithTitle:@"Error Fetching Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (void)findConversationWithTaker {
    // create query to access "author" key within a conversation's post
    PFQuery *postsQuery = [PFQuery queryWithClassName:@"Post"];
    [postsQuery whereKey:@"author" equalTo:self.user];
    
    // create query for conversations with current user as seeker, post author as author, post as post
    PFQuery *conversationsQuery=[PFQuery queryWithClassName:@"Conversation"];
    [conversationsQuery includeKey:@"post"];
    [conversationsQuery whereKey:@"post" matchesQuery:postsQuery];
    [conversationsQuery whereKey:@"post" equalTo:self.post];
    
    [conversationsQuery includeKey: @"seeker"];
    [conversationsQuery whereKey:@"seeker" equalTo:self.post.taker];
    
    [conversationsQuery includeKey: @"messages"];
    
    [conversationsQuery getFirstObjectInBackgroundWithBlock:^(NSObject *conversation, NSError*error){
        if (conversation) {
            self.conversation = (Conversation *)conversation;
            [self performSegueWithIdentifier:postDetailsToMessageSegue sender:nil];
        } else {
            [Alert callAlertWithTitle:@"Error Fetching Conversation" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (void)deletePost {
    [self.post deletePostAndConversationsWithCompletion:^(BOOL didDeletePost, NSError *error) {
        if (didDeletePost) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self.delegate reloadData];
        } else {
            [Alert callAlertWithTitle:@"Error Deleting Post" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (void)cancelJob {
    [self.post cancelJobWithConversation:self.post.conversation withCompletion:^(BOOL didCancelJob, NSError *error) {
        if (didCancelJob) {
            [self reloadDetails];
        } else {
            [Alert callAlertWithTitle:@"Error Cancelling Job" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:self];
        }
    }];
}

- (void)setMapWithAnnotation{
    //format map
    self.postLocationMap.layer.cornerRadius=5.0;
    self.postLocationMap.layer.borderColor=[[Colors primaryBlueColor]CGColor];
    self.postLocationMap.layer.borderWidth=1.0;
    
    //add shadow
    self.postLocationMap.layer.shadowOffset=CGSizeMake(0, 0);
    self.postLocationMap.layer.shadowOpacity=0.7;
    self.postLocationMap.layer.shadowRadius=1.0;
    self.postLocationMap.clipsToBounds = false;
    self.postLocationMap.layer.shadowColor=[[UIColor blackColor]CGColor];
    
    //set map with displayed annotation
    geoPointToCoord.latitude=self.post.location.latitude;
    geoPointToCoord.longitude=self.post.location.longitude;
    [self.postLocationMap setRegion:MKCoordinateRegionMake(geoPointToCoord, MKCoordinateSpanMake(.09f, .09f)) animated:YES];
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=geoPointToCoord;
    [self.postLocationMap addAnnotation:annotation];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:postDetailsToMessageSegue]) {
        ConversationDetailViewController *conversationDetailController = [segue destinationViewController];
        conversationDetailController.delegate = self;
        conversationDetailController.conversation = self.conversation;
        if ([self.user.objectId isEqualToString:self.post.author.objectId] && self.post.taker) {
            conversationDetailController.otherUser = self.post.taker;
        } else {
            conversationDetailController.otherUser = self.post.author;
        }
    } else if ([segue.identifier isEqualToString:postDetailsToEditPostSegue]) {
        ComposeNewPostViewController *editPostViewController = [segue destinationViewController];
        editPostViewController.delegate = self;
        editPostViewController.post = self.post;
    }
}

@end
