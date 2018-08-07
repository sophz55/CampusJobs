//
//  AppScheme.h
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

#import <Foundation/Foundation.h>

#import <MaterialComponents/MaterialButtons+ButtonThemer.h>
#import <MaterialComponents/MaterialColorScheme.h>
#import <MaterialComponents/MaterialTypographyScheme.h>


/*
 AppScheme is a central object for setting the application's colors and typography.
 */
@interface AppScheme : NSObject

+ (instancetype)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;

@property(nonnull, readonly, nonatomic) MDCSemanticColorScheme *colorScheme;
@property(nonnull, readonly, nonatomic) MDCTypographyScheme *typographyScheme;
@property(nonnull, readonly, nonatomic) MDCButtonScheme *buttonScheme;

@end
