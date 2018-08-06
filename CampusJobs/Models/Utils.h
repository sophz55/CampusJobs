//
//  Utils.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MaterialComponents/MaterialAppBar.h>


@interface Utils : NSObject

+ (void)animateView:(UIView *)view withDistance:(CGFloat)distance up:(BOOL)up;

+ (double)calculateDistance:(PFGeoPoint *)postLocation betweenUserandPost:(PFGeoPoint *)userLocation;

+ (void)addGreyGradientToView:(UIView *)view;

+ (void)addBlueGradientToView:(UIView *)view;

+ (void)formatColorForAppBar:(MDCAppBar *)appBar;

@end
