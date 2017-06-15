//
//  NoteCell.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "TaskC+CoreDataClass.h"




@interface NoteCell : UITableViewCell

-(NoteCell *)loadCell:(UITableViewCell *)cell task:(TaskC *)task;

@property (nonatomic, copy) void(^actionNoteChecked)(void);
@property (copy) void (^blockProperty)(void);

-(void)checkBtnPresserd;



@end

