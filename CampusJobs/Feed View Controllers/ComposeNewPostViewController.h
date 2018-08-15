//
//  ComposeNewPostViewController.h
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <MapKit/MapKit.h>

@protocol ComposePostDelegate
- (void)reloadDetails;
@end

@interface ComposeNewPostViewController : UIViewController
@property (weak, nonatomic) id <ComposePostDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *locationAddressLabel;
@property (strong, nonatomic) PFGeoPoint * savedLocation;
@property (strong, nonatomic) NSString * savedLocationAddress;
@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet MKMapView *postMapView;

- (void)getAddressFromCoordinate:(PFGeoPoint *)geoPointLocation;


@end
