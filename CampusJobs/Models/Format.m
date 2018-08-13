//
//  Format.m
//  CampusJobs
//
//  Created by Sophia Zheng on 8/6/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Format.h"
#import "Colors.h"
#import <ChameleonFramework/Chameleon.h>
#import <MaterialComponents/MaterialAppBar+ColorThemer.h>
#import <MaterialComponents/MaterialAppBar+TypographyThemer.h>
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+TypographyThemer.h>
#import <MaterialComponents/MaterialTextFields+ColorThemer.h>
#import <MaterialComponents/MaterialTextFields+TypographyThemer.h>
#import "AppScheme.h"
#import "StringConstants.h"

@implementation Format

+ (void)addGreyGradientToView:(UIView *)view {
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[UIColor whiteColor]];
    [colors addObject:[Colors secondaryGreyLighterColor]];
    view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:view.frame andColors:colors];
}

+ (void)addBlueGradientToView:(UIView *)view {
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[Colors primaryBlueDarkColor]];
    [colors addObject:[Colors primaryBlueColor]];
    [colors addObject:[Colors primaryBlueDarkColor]];
    view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:view.frame andColors:colors];
}

+ (void)formatAppBar:(MDCAppBar *)appBar withTitle:(NSString *)title {
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    [MDCAppBarColorThemer applySemanticColorScheme:colorScheme toAppBar:appBar];
    appBar.navigationBar.backgroundColor = [Colors primaryBlueDarkColor];
    appBar.headerViewController.headerView.backgroundColor = appBar.navigationBar.backgroundColor;
    
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    
    appBar.navigationBar.title = [title uppercaseString];
    appBar.navigationBar.titleTextColor = colorScheme.onSecondaryColor;
    appBar.navigationBar.titleFont = typographyScheme.headline4;
}

+ (void)formatBarButton:(UIBarButtonItem *)button {
    [button setTitle:[button.title uppercaseString]];
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    [button setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: typographyScheme.button, NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    button.width = 0.0f;
}

+ (void)formatRaisedButton:(MDCButton *)button {
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    [MDCContainedButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:button];
    
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    [button setTitleFont:typographyScheme.button forState:UIControlStateNormal];
    
    button.layer.cornerRadius=5.0;
    [button setTitle:[button.titleLabel.text uppercaseString] forState:UIControlStateNormal];
    [button sizeToFit];
}

+ (void)formatFlatButton:(MDCButton *)button {
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    [MDCTextButtonColorThemer applySemanticColorScheme:colorScheme
                                                   toButton:button];
    [button setTitleColor:[Colors secondaryGreyTextColor] forState:UIControlStateNormal];
    [button setInkColor:[Colors primaryBlueDarkColor]];
    
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    [button setTitleFont:typographyScheme.button forState:UIControlStateNormal];
    
    button.layer.cornerRadius=5.0;
    [button setTitle:[button.titleLabel.text uppercaseString] forState:UIControlStateNormal];
    
    [button sizeToFit];
}

+ (void)centerHorizontalView:(UIView *)view inView:(UIView *)outerView {
    CGFloat originx = (outerView.frame.size.width - view.frame.size.width)/2;
    view.frame = CGRectMake(originx, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

+ (void)centerVerticalView:(UIView *)view inView:(UIView *)outerView {
    CGFloat originy = (outerView.frame.size.height - view.frame.size.height)/2;
    view.frame = CGRectMake(view.frame.origin.x, originy, view.frame.size.width, view.frame.size.height);
}

+ (void)formatProfilePictureForUser:(PFUser *)user withView:(PFImageView *)view {
    view.layer.cornerRadius = view.frame.size.width / 2;
    view.clipsToBounds = YES;
    
    //Placeholder for profile picture while waiting for load
    view.image = [UIImage imageNamed:@"image_placeholder"];
    
    //format profile picture border
    view.layer.borderColor = [[Colors primaryBlueColor] CGColor];
    view.layer.borderWidth = view.frame.size.width * .03;
    
    [user fetchIfNeededInBackgroundWithBlock:^(PFObject *user, NSError *error) {
        if (user) {
            //set profile picture (if there is one already selected)
            if(user[profileImageFile]){
                view.file = user[profileImageFile];
                [view loadInBackground];
            }
        }
    }];
}

+ (void)configurePlaceholderView:(UIView *)view withLabel:(UILabel *)label{
    //placeholder view while table data loads
    view.hidden = NO;
    view.backgroundColor = [Colors secondaryGreyLighterColor];
    label.textColor = [Colors secondaryGreyColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.font = [UIFont fontWithName:lightItalicFontName size:20];
}

+ (void)formatTextFieldController:(MDCTextInputControllerBase *)controller withNormalColor:(UIColor *)color {
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    [MDCTextFieldColorThemer applySemanticColorScheme:colorScheme
                                toTextInputController:controller];
    controller.inlinePlaceholderColor = color;
    controller.normalColor = color;
    controller.floatingPlaceholderNormalColor = color;
}

+ (void)configureCellShadow:(UITableViewCell *)cell {
    cell.layer.shadowOffset=CGSizeMake(0, 0);
    cell.layer.shadowOpacity=0.3;
    cell.layer.shadowRadius=1.0;
    cell.clipsToBounds = false;
    cell.layer.shadowColor=[[UIColor blackColor] CGColor];
}

@end
