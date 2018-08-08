//
//  SimpleMessage.m
//  BackgroundFetchDemo
//
//  Created by Somtochukwu Nweke on 7/29/18.
//  Copyright © 2018 So What. All rights reserved.
//

#import "SimpleMessage.h"

@implementation SimpleMessage

- (id)init
{
    self = [super init];
    if (self) {
        self.date = [NSDate date];
        self.unread = YES;
    }
    return self;
}

@end
