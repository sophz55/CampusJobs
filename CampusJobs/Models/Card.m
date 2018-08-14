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
@dynamic zipcode;
@dynamic state;
@dynamic city;

// conforming to PFSubclassing protocol
+ (nonnull NSString *) parseClassName{
    return @"Card";
}

- (BOOL)isValidCard {
    return (
            self.billingName.length > 0 &&
            self.cardNumber.length > 10 &&
            self.expDate.length > 4 && self.expDate.length < 6 &&
            self.securityCode.length > 2 && self.securityCode.length < 5 &&
            self.addressLine1.length > 0 &&
            self.zipcode.length > 4 &&
            self.state.length > 0 &&
            self.city.length > 0
            );
}

@end
