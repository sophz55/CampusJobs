//
//  Card.h
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Card : PFObject <PFSubclassing>

@property (weak, nonatomic) NSString *billingName;
@property (weak, nonatomic) NSString *cardNumber;
@property (weak, nonatomic) NSString *expDate;
@property (weak, nonatomic) NSString *securityCode;
@property (weak, nonatomic) NSString *addressLine1;
@property (weak, nonatomic) NSString *addressLine2;
@property (weak, nonatomic) NSString *zipcode;
@property (weak, nonatomic) NSString *state;
@property (weak, nonatomic) NSString *city;

@end
