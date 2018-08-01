//
//  SocialViewController.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialViewController : UIViewController {


NSTimer *timer;

}

@property(strong, nonatomic) NSString *detail;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actInd;



@end

