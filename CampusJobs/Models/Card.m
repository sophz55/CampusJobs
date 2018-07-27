//
//  Card.m
//  CampusJobs
//
//  Created by Sophia Zheng on 7/26/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "Card.h"

@implementation Card

@dynamic billingName;
@dynamic cardNumber;
@dynamic expDate;
@dynamic securityCode;
@dynamic addressLine1;
@dynamic addressLine2;
@dynamic cityStateZip;

// conforming to PFSubclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Card";
}

@end
