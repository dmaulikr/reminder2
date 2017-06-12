//
//  PopTaskViewController.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"


@protocol PopViewControllerDellegate <NSObject>

-(void)attachmentsBrnPressed;


@end

@interface PopTaskViewController : UIViewController


@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) id<PopViewControllerDellegate> delegate;

@end
