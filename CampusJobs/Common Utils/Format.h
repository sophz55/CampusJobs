//
//  Format.h
//  CampusJobs
//
//  Created by Sophia Zheng on 8/6/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MaterialComponents/MaterialAppBar.h>
#import <MaterialComponents/MaterialButtons.h>
#import <MaterialComponents/MaterialTextFields.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface Format : NSObject

+ (void)addGreyGradientToView:(UIView *)view;

+ (void)addBlueGradientToView:(UIView *)view;

+ (void)formatAppBar:(MDCAppBar *)appBar withTitle:(NSString *)title;

+ (void)formatBarButton:(UIBarButtonItem *)button;

+ (void)formatRaisedButton:(MDCButton *)button;

+ (void)formatFlatButton:(MDCButton *)button;

+ (void)centerHorizontalView:(UIView *)view inView:(UIView *)outerView;

+ (void)centerVerticalView:(UIView *)view inView:(UIView *)outerView;

+ (void)formatProfilePictureForUser:(PFUser *)user withView:(PFImageView *)view;

+ (void)configurePlaceholderView:(UIView *)view withLabel:(UILabel *)label;

+ (void)formatTextFieldController:(MDCTextInputControllerBase *)controller withNormalColor:(UIColor *)color;

+ (void)configureCellShadow:(UITableViewCell *)cell;

@end
