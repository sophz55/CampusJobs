//
//  SuggestPriceViewController.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/20/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SuggestPriceViewController.h"
#import "Alert.h"
#import "ConversationDetailViewController.h"
#import <MaterialComponents/MaterialTextFields.h>
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialTypography.h>
#import "Colors.h"
#import "AppScheme.h"
#import "Format.h"

@interface SuggestPriceViewController ()

@property (weak, nonatomic) IBOutlet MDCTextField *suggestedPriceTextField;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *cancelButton;
@property (weak, nonatomic) IBOutlet MDCRaisedButton *suggestButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation SuggestPriceViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.cancelButton sizeToFit];
    [self.suggestButton sizeToFit];
    self.delegate.showingSuggestViewController = YES;
    
    self.backgroundView.frame = self.view.bounds;
    self.backgroundView.backgroundColor = [Colors secondaryGreyDarkColor];
    self.backgroundView.alpha = .8;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.popUpView.layer.cornerRadius = 10;
    self.popUpView.clipsToBounds = YES;
    self.popUpView.alpha = 1;
    [Format centerHorizontalView:self.popUpView inView:self.view];
    
    self.titleLabel.frame = CGRectMake(0, self.popUpView.frame.origin.y + 10, 0, 0);
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    self.titleLabel.text = @"SUGGEST A PRICE";
    self.titleLabel.font = typographyScheme.headline6;
    [self.titleLabel sizeToFit];
    [Format centerHorizontalView:self.titleLabel inView:self.view];
    
    self.suggestedPriceTextField.frame = CGRectMake(0, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 6, 80, 50);
    [Format centerHorizontalView:self.suggestedPriceTextField inView:self.view];
    
    [Format formatRaisedButton:self.cancelButton];
    [Format formatRaisedButton:self.suggestButton];
    CGFloat buttonWidth = MAX(self.cancelButton.frame.size.width, self.suggestButton.frame.size.width);
    CGFloat buttonHeight = self.cancelButton.frame.size.height;
    CGFloat inset = (self.popUpView.frame.size.width - 2 * buttonWidth) / 3;
    self.cancelButton.frame = CGRectMake(inset, self.popUpView.frame.size.height - inset - buttonHeight, buttonWidth, buttonHeight);
    self.suggestButton.frame = CGRectMake(self.popUpView.frame.size.width - buttonWidth - inset, self.cancelButton.frame.origin.y, buttonWidth, buttonHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)didTapCancelButton:(id)sender {
    self.suggestedPriceTextField.text = @"";
    [self dismissViewControllerAnimated:YES completion:^{
        self.delegate.showingSuggestViewController = NO;
    }];
}

- (IBAction)didTapSuggestButton:(id)sender {
    __unsafe_unretained typeof(self) weakSelf = self;
    if (![self.suggestedPriceTextField.text isEqualToString:@""]) {
        [self.conversation addToConversationWithSystemMessageWithPrice:[self.suggestedPriceTextField.text intValue] withText:[NSString stringWithFormat:@"%@ has offered $%@.", [PFUser currentUser].username, self.suggestedPriceTextField.text] withSender:[PFUser currentUser] withReceiver:self.otherUser withCompletion:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                weakSelf.suggestedPriceTextField.text = @"";
                [weakSelf dismissViewControllerAnimated:YES completion: ^ {
                    weakSelf.delegate.showingSuggestViewController = NO;
                    [weakSelf.delegate reloadData];
                }];
            } else {
                [Alert callAlertWithTitle:@"Error sending message" alertMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] viewController:weakSelf];
            }
        }];
    } else {
        [Alert callAlertWithTitle:@"Couldn't send price" alertMessage:@"Cannot have empty price field" viewController:self];
    }
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
