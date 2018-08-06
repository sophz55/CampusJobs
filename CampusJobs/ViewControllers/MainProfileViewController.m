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
#import <ChameleonFramework/Chameleon.h>
#import <MaterialComponents/MaterialButtons.h>
#import "MaterialButtons+ButtonThemer.h"
#import <MaterialComponents/MaterialAppBar+ColorThemer.h>
#import <MaterialComponents/MaterialTextFields+TypographyThemer.h>
#import "AppScheme.h"
#import "Format.h"


@interface MainProfileViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) PFUser *currentUser;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIView *roundedEdgeView;
@property (weak, nonatomic) IBOutlet MDCFlatButton *editProfPicButton;
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
    [self configureNavigationBar];
    [self setMainPageLabels];
    [self formatViewLayout];
    self.buttonScheme = [[MDCButtonScheme alloc] init];
    [self formatPic];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self formatButtons];
    
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    self.nameLabel.font = typographyScheme.headline4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureNavigationBar {
    self.appBar = [[MDCAppBar alloc] init];
    [self addChildViewController:_appBar.headerViewController];
    [self.appBar addSubviewsToParent];
    [Format formatAppBar:self.appBar withTitle:@"YOUR PROFILE"];
}

//Helper method
- (void)formatViewLayout{
    //Format top view
    self.topView.frame=CGRectMake(0,0, self.view.frame.size.width, 320);
    NSMutableArray *topColors = [NSMutableArray array];
    [topColors addObject:[Colors primaryBlueLightColor]];
    [topColors addObject:[Colors primaryBlueColor]];
    self.topView.backgroundColor=[UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.topView.frame andColors:topColors];
    
    //format rounded view
    self.roundedEdgeView.frame=CGRectMake(-self.view.frame.size.width/2, self.topView.frame.size.height-50, self.view.frame.size.width * 2, 100);
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
    user[@"profileImageFile"]=[self getPFFileFromImage:editedImage];
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
    self.usernameLabel.text=self.currentUser.username;
    self.emailLabel.text=self.currentUser.email;
    self.nameLabel.text=self.currentUser[@"name"];
}

//Helper method
- (void)formatPic {
    //Create a circle for profile picture
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    self.profilePicture.clipsToBounds = YES;
    
    //Placeholder for profile picture while waiting for load
    self.profilePicture.image = [UIImage imageNamed:@"image_placeholder"];
    
    //format profile picture border
    self.profilePicture.layer.borderColor=[[Colors primaryOrangeColor]CGColor];
    self.profilePicture.layer.borderWidth=2.0;
    
    //set profile picture (if there is one already selected)
    if(self.currentUser[@"profileImageFile"]){
        self.profilePicture.file = self.currentUser[@"profileImageFile"];
        [self.profilePicture loadInBackground];
    }
}

- (void)formatButtons {
    //Edit profile picture button
    self.editProfPicButton.layer.borderWidth=.25f;
    [Format formatFlatButton:self.editProfPicButton];
    [Format centerHorizontalView:self.editProfPicButton inView:self.view];
    
    //Add rounded edges, typography, color theme to bottom view buttons
    [Format formatRaisedButton:self.editPersonalSettingsButton];
    self.editPersonalSettingsButton.backgroundColor = [Colors secondaryGreyLightColor];
    
    [Format formatRaisedButton:self.editPaymentInfoButton];
    self.editPaymentInfoButton.backgroundColor = [Colors secondaryGreyLightColor];
    
    [Format formatRaisedButton:self.editDesiredRadiusButton];
    self.editDesiredRadiusButton.backgroundColor = [Colors secondaryGreyLightColor];
    
    
    //Center bottom view buttons
    [Format centerHorizontalView:self.editPersonalSettingsButton inView:self.view];
    [Format centerHorizontalView:self.editPaymentInfoButton inView:self.view];
    [Format centerHorizontalView:self.editDesiredRadiusButton inView:self.view];
    
    //Change button shadow to selected orange
    self.editPersonalSettingsButton.layer.shadowColor=[[Colors primaryOrangeColor]CGColor];
    self.editPaymentInfoButton.layer.shadowColor=[[Colors primaryOrangeColor]CGColor];
    self.editDesiredRadiusButton.layer.shadowColor=[[Colors primaryOrangeColor]CGColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    Get the new view controller using [segue destinationViewController].
//    Pass the selected object to the new view controller.
}
 */

@end
