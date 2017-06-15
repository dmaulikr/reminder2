//
//  AllNotesCell.h
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskC+CoreDataClass.h"

@interface AllNotesCell : UITableViewCell

-(AllNotesCell *)loadCell:(AllNotesCell *)cell task:(TaskC *)task;

@property (nonatomic, copy) void(^actionNoteChecked)(void);
@property (copy) void (^blockProperty)(void);



//@property (nonatomic, weak) id<MainViewControllerDelegate>  delegate;

-(void)checkBtnPresserd;

@end
