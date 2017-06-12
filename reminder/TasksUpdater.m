//
//  TasksUpdater.m
//  reminder
//
//  Created by Nikola on 6/9/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "TasksUpdater.h"

@implementation TasksUpdater

@synthesize delegate;

- (void) myMethodToDoStuff {
    [self.delegate getRowIndex];
}
- (void)updaterUpdateRow
{
    if (self.delegate)
    {
        [self.delegate getRowIndex];
    }
}
@end
