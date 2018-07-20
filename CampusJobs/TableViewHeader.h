//
//  TableViewHeader.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/20/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewHeader : UIImageView

{
    UILabel *label;
}

-(id)initWithText:(NSString *)text;
-(void)setText:(NSString *)text;


@end
