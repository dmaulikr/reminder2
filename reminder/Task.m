//
//  Task.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Task.h"

@implementation Task

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.attachmentsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
