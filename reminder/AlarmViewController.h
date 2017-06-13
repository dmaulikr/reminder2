//
//  AlarmViewController.h
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TaskC+CoreDataClass.h"



@interface AlarmViewController : UIViewController

@property (strong, nonatomic) Task *taskOpened;
@property (strong, nonatomic) TaskC *taskCOpened;

@property (nonatomic, copy) void(^actionDatePicked)(NSDate *);
@property (nonatomic, copy) void(^actionDateDone)(void);


@end
