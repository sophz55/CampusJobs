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

@interface Format : NSObject

+ (void)addGreyGradientToView:(UIView *)view;

+ (void)addBlueGradientToView:(UIView *)view;

+ (void)formatAppBar:(MDCAppBar *)appBar withTitle:(NSString *)title;

+ (void)formatRaisedButton:(MDCButton *)button;

+ (void)formatFlatButton:(MDCButton *)button;

+ (void)centerHorizontalView:(UIView *)view inView:(UIView *)outerView;

@end
