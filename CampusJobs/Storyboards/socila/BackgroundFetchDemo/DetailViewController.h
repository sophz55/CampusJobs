//
//  DetailViewController.h
//  BackgroundFetchDemo
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleMessage.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) SimpleMessage *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
