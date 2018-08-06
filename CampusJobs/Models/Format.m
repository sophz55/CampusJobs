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
#import "Colors.h"
#import <MaterialComponents/MaterialAppBar+ColorThemer.h>
#import <MaterialComponents/MaterialAppBar+TypographyThemer.h>
#import <MaterialComponents/MaterialButtons+ColorThemer.h>
#import <MaterialComponents/MaterialButtons+TypographyThemer.h>
#import "AppScheme.h"

@implementation Format

+ (void)addGreyGradientToView:(UIView *)view {
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[UIColor whiteColor]];
    [colors addObject:[Colors secondaryGreyLighterColor]];
    view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:view.frame andColors:colors];
}

+ (void)addBlueGradientToView:(UIView *)view {
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:[Colors primaryBlueLightColor]];
    [colors addObject:[Colors primaryBlueColor]];
    [colors addObject:[Colors primaryBlueDarkColor]];
    view.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:view.frame andColors:colors];
}

+ (void)formatAppBar:(MDCAppBar *)appBar withTitle:(NSString *)title {
    id<MDCColorScheming> colorScheme = [AppScheme sharedInstance].colorScheme;
    [MDCAppBarColorThemer applySemanticColorScheme:colorScheme toAppBar:appBar];
    appBar.navigationBar.backgroundColor = [Colors primaryBlueColor];
    appBar.headerViewController.headerView.backgroundColor = appBar.navigationBar.backgroundColor;
    
    id<MDCTypographyScheming> typographyScheme = [AppScheme sharedInstance].typographyScheme;
    [MDCAppBarTypographyThemer applyTypographyScheme:typographyScheme toAppBar:appBar];
    
    appBar.navigationBar.title = [title uppercaseString];
    appBar.navigationBar.titleTextColor = [UIColor whiteColor];
    appBar.navigationBar.titleFont = typographyScheme.body1;
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

@end
