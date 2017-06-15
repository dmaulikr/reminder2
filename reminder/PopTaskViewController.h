//
//  PopTaskViewController.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TaskC+CoreDataClass.h"


@protocol PopViewControllerDellegate <NSObject>

@optional
-(void)attachmentsBrnPressed;
-(void)taskUpdated;


@end

@interface PopTaskViewController : UIViewController


@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) id<PopViewControllerDellegate> delegate;
@property (strong, nonatomic) TaskC *taskC;

@end
