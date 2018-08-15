//
//  NearbyPostingsViewController.h
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearbyPostingsViewController : UIViewController

- (void)fetchNearbyPosts;
- (void)displayRadius;

@property (retain, nonatomic) NSMutableArray * nearbyPostingsArray;

@end
