//
//  ComposeNewPostViewController.h
//  CampusJobs
//
//  Created by Sophia Khezri on 7/16/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface ComposeNewPostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *enteredTitle;
@property (weak, nonatomic) IBOutlet UITextField *enteredDescription;


@end
