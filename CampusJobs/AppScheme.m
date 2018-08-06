//
//  AppScheme.m
//  CampusJobs
//
//  Created by Sophia Zheng on 8/2/18.
//  Copyright © 2018 So What. All rights reserved.
//

/*
 Copyright 2018-present the Material Components for iOS authors. All Rights Reserved.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "AppScheme.h"
#import "Colors.h"

@implementation AppScheme {
    MDCSemanticColorScheme *_colorScheme;
    MDCTypographyScheme *_typographyScheme;
}

+ (instancetype)sharedInstance {
    static AppScheme *scheme;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //TODO: Change scheme to initialize with initAlternativeSingleton
        scheme = [[AppScheme alloc] initStandardSingleton];
    });
    return scheme;
}

- (instancetype)initStandardSingleton {
    self = [super init];
    if (self) {
        // Instantiate a MDCSemanticColorScheme object and modify it to our chosen colors
        _colorScheme =
        [[MDCSemanticColorScheme alloc] initWithDefaults:MDCColorSchemeDefaultsMaterial201804];
        //TODO: Add our custom colors after this line
        _colorScheme.primaryColor = [Colors primaryOrangeColor];
        _colorScheme.onPrimaryColor = [Colors secondaryGreyTextColor];
        _colorScheme.secondaryColor = [Colors primaryBlueColor];
        _colorScheme.onSecondaryColor = [Colors secondaryGreyTextColor];
        _colorScheme.surfaceColor = [Colors primaryBlueLightColor];
        _colorScheme.onSurfaceColor=[UIColor whiteColor];
        _colorScheme.backgroundColor = [Colors secondaryGreyLightColor];
        _colorScheme.onBackgroundColor = [Colors secondaryGreyTextColor];
        _colorScheme.errorColor =
        [UIColor colorWithRed:197.0/255.0 green:3.0/255.0 blue:43.0/255.0 alpha:1.0];
        
        // Instantiate a MDCSemanticColorScheme object and modify it to our chosen colors
        _typographyScheme = [[MDCTypographyScheme alloc] initWithDefaults:MDCTypographySchemeDefaultsMaterial201804];
        //TODO: Add our custom fonts after this line
        NSString *lightFont = @"RobotoCondensed-Light";
        NSString *boldFont = @"RobotoCondensed-Bold";
        NSString *boldItalicFont = @"RobotoCondensed-BoldItalic";
        NSString *lightItalicFont = @"RobotoCondensed-LightItalic";
        NSString *regularFont = @"RobotoCondensed-Regular";
        NSString *italicFont = @"RobotoCondensed-Italic";
        _typographyScheme.headline1 = [UIFont fontWithName:lightFont size:96.0];
        _typographyScheme.headline2 = [UIFont fontWithName:lightFont size:60.0];
        _typographyScheme.headline3 = [UIFont fontWithName:regularFont size:48.0];
        _typographyScheme.headline4 = [UIFont fontWithName:regularFont size:34.0];
        _typographyScheme.headline5 = [UIFont fontWithName:regularFont size:24.0];
        _typographyScheme.headline6 = [UIFont fontWithName:boldFont size:20.0];
        _typographyScheme.subtitle1 = [UIFont fontWithName:lightFont size:16.0];
        _typographyScheme.subtitle2 = [UIFont fontWithName:boldFont size:14.0];
        _typographyScheme.body1 = [UIFont fontWithName:regularFont size:16.0];
        _typographyScheme.body2 = [UIFont fontWithName:regularFont size:14.0];
        _typographyScheme.caption = [UIFont fontWithName:boldFont size:14.0];
        _typographyScheme.button = [UIFont fontWithName:regularFont size:16.0];
        _typographyScheme.overline = [UIFont fontWithName:regularFont size:18.0];
        
        
        // Create a button scheme based off our custom colors and typography
        _buttonScheme = [[MDCButtonScheme alloc] init];
        _buttonScheme.colorScheme = _colorScheme;
        _buttonScheme.typographyScheme = _typographyScheme;
    }
    return self;
}

- (UIColor *)primaryColor {
    return _colorScheme.primaryColor;
}

- (UIColor *)primaryColorVariant{
    return _colorScheme.primaryColorVariant;
}

- (UIColor *)secondaryColor{
    return _colorScheme.secondaryColor;
}

- (UIColor *)errorColor{
    return _colorScheme.errorColor;
}

- (UIColor *)surfaceColor{
    return _colorScheme.surfaceColor;
}

- (UIColor *)backgroundColor{
    return _colorScheme.backgroundColor;
}

- (UIColor *)onPrimaryColor{
    return _colorScheme.onPrimaryColor;
}

- (UIColor *)onSecondaryColor{
    return _colorScheme.onSecondaryColor;
}

- (UIColor *)onSurfaceColor{
    return _colorScheme.onSurfaceColor;
}

- (UIColor *)onBackgroundColor{
    return _colorScheme.onBackgroundColor;
}

- (UIFont *)headline1 {
    return _typographyScheme.headline1;
}

- (UIFont *)headline2 {
    return _typographyScheme.headline2;
}

- (UIFont *)headline3 {
    return _typographyScheme.headline3;
}

- (UIFont *)headline4 {
    return _typographyScheme.headline4;
}

- (UIFont *)headline5 {
    return _typographyScheme.headline5;
}

- (UIFont *)headline6 {
    return _typographyScheme.headline6;
}

- (UIFont *)subtitle1 {
    return _typographyScheme.subtitle1;
}

- (UIFont *)subtitle2 {
    return _typographyScheme.subtitle2;
}

- (UIFont *)body1 {
    return _typographyScheme.body1;
}

- (UIFont *)body2 {
    return _typographyScheme.body2;
}

- (UIFont *)caption {
    return _typographyScheme.caption;
}

- (UIFont *)button {
    return _typographyScheme.button;
}

- (UIFont *)overline {
    return _typographyScheme.overline;
}

@end
