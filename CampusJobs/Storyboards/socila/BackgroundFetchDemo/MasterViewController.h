//
//  MasterViewController.h
//  BackgroundFetchDemo
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController

-(void) fetchNewData;

// this is the version to pass through the completionHandler
// -(void) fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
