//
//  SearchPostingsViewController.h
//  CampusJobs
//
//  Created by Sophia Zheng on 8/13/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPostingsViewController : UIViewController

@property (assign, nonatomic) BOOL isSearchingNearby; // YES -> search nearby postings, NO -> search your postings
@property (retain, nonatomic) NSMutableArray *allPostingsArray;

@end
