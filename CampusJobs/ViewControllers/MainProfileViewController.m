//
//  MainProfileViewController.m
//  CampusJobs
//
//  Created by Sophia Khezri on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "MainProfileViewController.h"
#import "Parse.h"
#import "ParseUI.h"
#import "Colors.h"
#import "Utils.h"
#import "StringConstants.h"
#import <ChameleonFramework/Chameleon.h>
#import <MaterialComponents/MaterialButtons.h>
#import "MaterialButtons+ButtonThemer.h"
#import <MaterialComponents/MaterialAppBar+ColorThemer.h>
#import <MaterialComponents/MaterialTextFields+TypographyThemer.h>
#import "AppScheme.h"
#import "Format.h"
#import "SegueConstants.h"

@interface MainProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIView *roundedEdgeView;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *editProfPicButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *editPersonalSettingsButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *editPaymentInfoButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *editDesiredRadiusButton;
@property (strong, nonatomic) MDCAppBar *appBar;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) MDCButtonScheme* buttonScheme;


@end

@implementation MainProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser=[PFUser currentUser];
    [self configureLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureTopNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    [Format formatAppBar:self.appBar withTitle:@"YOUR PROFILE"];
}

//automatically style status bar
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.appBar.headerViewController;
}

- (void)configureLayout {
    [self configureTopNavigationBar];
    [self setMainPageLabels];
    [self formatPic];
    [self formatButtons];
    self.buttonScheme = [[MDCButtonScheme alloc] init];
    
    self.profilePicture.frame = CGRectMake(self.profilePicture.frame.origin.x, 76, self.profilePicture.frame.size.width, self.profilePicture.frame.size.height);
    
    self.editProfPicButton.frame = CGRectMake(0, self.profilePicture.frame.origin.y + self.profilePicture.frame.size.height + 5, self.editProfPicButton.frame.size.width, 20);
    [Format centerHorizontalView:self.editProfPicButton inView:self.view];
    
    self.nameLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.editProfPicButton.frame.origin.y + self.editProfPicButton.frame.size.height + 10, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
    self.usernameLabel.frame = CGRectMake(self.usernameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 2, self.usernameLabel.frame.size.width, self.usernameLabel.frame.size.height);
    
    self.emailLabel.frame = CGRectMake(self.emailLabel.frame.origin.x, self.usernameLabel.frame.origin.y + self.usernameLabel.frame.size.height + 2, self.emailLabel.frame.size.width, self.emailLabel.frame.size.height);
    
    [self formatBackgroundAtHeight:self.emailLabel.frame.origin.y - 60];
    
    CGFloat topButtonOriginY = self.roundedEdgeView.frame.origin.y + self.roundedEdgeView.frame.size.height + 28;
    CGFloat buttonHeight = self.editPersonalSettingsButton.frame.size.height;
    CGFloat space = buttonHeight + 20;
    self.editPersonalSettingsButton.frame = CGRectMake(self.editPersonalSettingsButton.frame.origin.x, topButtonOriginY, self.editPersonalSettingsButton.frame.size.width, buttonHeight);
    self.editPaymentInfoButton.frame = CGRectMake(self.editPaymentInfoButton.frame.origin.x, topButtonOriginY + space, self.editPaymentInfoButton.frame.size.width, buttonHeight);
    self.editDesiredRadiusButton.frame = CGRectMake(self.editDesiredRadiusButton.frame.origin.x, topButtonOriginY + 2 * space, self.editDesiredRadiusButton.frame.size.width, buttonHeight);
}


//Helper method
- (void)formatBackgroundAtHeight:(CGFloat)height {
    //Format top view
    self.topView.frame=CGRectMake(0, 75, self.view.frame.size.width, height-20);
    NSMutableArray *topColors = [NSMutableArray array];
    [topColors addObject:[Colors primaryBlueDarkColor]];
    [topColors addObject:[Colors primaryBlueColor]];
    self.topView.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.topView.frame andColors:topColors];
    
    //format rounded view
    self.roundedEdgeView.frame = CGRectMake(-self.view.frame.size.width/2, self.topView.frame.origin.y + self.topView.frame.size.height - 75, self.view.frame.size.width * 2, 150);
    self.roundedEdgeView.layer.cornerRadius=self.roundedEdgeView.frame.size.width / 2;
    self.roundedEdgeView.clipsToBounds=YES;
    self.roundedEdgeView.backgroundColor=[Colors primaryBlueColor];
    
    //format bottom view
    NSMutableArray *bottomColors = [NSMutableArray array];
    [bottomColors addObject:[Colors secondaryGreyLightColor]];
    [bottomColors addObject:[UIColor whiteColor]];
    [bottomColors addObject:[Colors secondaryGreyLightColor]];
    self.view.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleRadial withFrame:self.view.frame andColors:bottomColors];
}

- (IBAction)didTapEditProfilePicButton:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Dismiss UIImagePickerController to go back to profile view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.profilePicture setImage:editedImage];
    PFUser *user= PFUser.currentUser;
    user[profileImageFile]=[self getPFFileFromImage:editedImage];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(!succeeded){
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

//Converts the image to a file
-(PFFile *)getPFFileFromImage: (UIImage * _Nullable) image{
    if(!image){
        return nil;
    }
    NSData * imageData =UIImagePNGRepresentation(image);
    if(!imageData){
        return nil;
    }
    return [PFFile fileWithName: @"image.png" data:imageData];
}

//Helper method
- (void)setMainPageLabels{
    //set labels
    self.nameLabel.text=self.currentUser[fullName];
    self.usernameLabel.text=self.currentUser.username;
    self.emailLabel.text=self.currentUser.email;
    
    //format labels
    self.nameLabel.font = [UIFont fontWithName:boldFontName size:29];
    self.usernameLabel.font =[UIFont fontWithName:regularFontName size:22];
    self.emailLabel.font = [UIFont fontWithName:lightFontName size:18];
    
    id<MDCColorScheming> colorScheme = [[AppScheme sharedInstance] colorScheme];
    self.nameLabel.textColor = colorScheme.onSecondaryColor;
    self.usernameLabel.textColor = self.nameLabel.textColor;
    self.emailLabel.textColor = self.nameLabel.textColor;
    
    [self.nameLabel sizeToFit];
    [self.usernameLabel sizeToFit];
    [self.emailLabel sizeToFit];
    
    //Center labels
    [Format centerHorizontalView:self.nameLabel inView:self.view];
    [Format centerHorizontalView:self.usernameLabel inView:self.view];
    [Format centerHorizontalView:self.emailLabel inView:self.view];
}

//Helper method
- (void)formatPic {
    [Format centerHorizontalView:self.profilePicture inView:self.view];
    [Format formatProfilePictureForUser:self.currentUser withView:self.profilePicture];
}

//called in main configuration
- (void)formatButtons {
    //Edit profile picture button
    [Format formatRaisedButton:self.editProfPicButton];
    self.editProfPicButton.layer.cornerRadius = 3.0;
    self.editProfPicButton.backgroundColor = [Colors secondaryGreyLightColor];
    [self.editProfPicButton setTitleFont:[UIFont fontWithName:regularFontName size:12] forState:UIControlStateNormal];
    [self.editProfPicButton sizeToFit];
    
    //color theme to bottom view buttons
    [Format formatRaisedButton:self.editPersonalSettingsButton];
    self.editPersonalSettingsButton.backgroundColor = self.editProfPicButton.backgroundColor;

    [Format formatRaisedButton:self.editPaymentInfoButton];
    self.editPaymentInfoButton.backgroundColor = self.editPersonalSettingsButton.backgroundColor;
    [Format formatRaisedButton:self.editDesiredRadiusButton];
    self.editDesiredRadiusButton.backgroundColor = self.editPersonalSettingsButton.backgroundColor;
    
    //Center bottom view buttons
    [Format centerHorizontalView:self.editProfPicButton inView:self.view];
    [Format centerHorizontalView:self.editPersonalSettingsButton inView:self.view];
    [Format centerHorizontalView:self.editPaymentInfoButton inView:self.view];
    [Format centerHorizontalView:self.editDesiredRadiusButton inView:self.view];
    
    //Change button shadow to selected orange
    self.editPersonalSettingsButton.layer.shadowColor = [[Colors primaryOrangeColor]CGColor];
    self.editPaymentInfoButton.layer.shadowColor = [[Colors primaryOrangeColor]CGColor];
    self.editDesiredRadiusButton.layer.shadowColor = [[Colors primaryOrangeColor]CGColor];
    self.editProfPicButton.layer.shadowColor=[[Colors secondaryGreyDarkColor]CGColor];
}

@end
