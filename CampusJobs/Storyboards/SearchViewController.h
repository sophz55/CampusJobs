//
//  SearchViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/24/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController {
    
    
     NSTimer *timer;
}
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *Indicator;


@end
