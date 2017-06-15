//
//  AddViewController.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddNewControllerDelegate <NSObject>

-(void)newTaskAdded;

@end


@interface AddViewController : UIViewController
- (IBAction)backAdd:(id)sender;
- (IBAction)btnAddPressed:(id)sender;

@property (weak, nonatomic) id<AddNewControllerDelegate> delegate;

@end
