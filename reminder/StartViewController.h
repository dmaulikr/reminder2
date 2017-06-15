//
//  StartViewController.h
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol StartViewControlellerDelegate <NSObject>

@optional
-(void)addBtnPressed;

@end

@interface StartViewController : UIViewController

@property (weak, nonatomic) id<StartViewControlellerDelegate> delegate;

@end
