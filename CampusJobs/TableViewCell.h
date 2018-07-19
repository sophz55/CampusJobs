//
//  TableViewCell.h
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/19/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *CellImageview;

@property (weak, nonatomic) IBOutlet UILabel *CellTitle;

@property (weak, nonatomic) IBOutlet UILabel *CellDescription;


@end
