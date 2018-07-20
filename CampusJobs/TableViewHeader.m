//
//  TableViewHeader.m
//  CampusJobs
//
//  Created by Somtochukwu Nweke on 7/20/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "TableViewHeader.h"

@implementation TableViewHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithText:(NSString *)text {
    
    UIImage *img = [UIImage imageNamed:@"Hey.jpg"];
    if ((self = [super initWithImage:img])) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 50)];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:30];
        label.text = text;
        label.numberOfLines = 1;
        [self addSubview:label];
        
    }
    
    return self;
}
-(void)setText:(NSString *)text{
    label.text = text;
    
}

@end
