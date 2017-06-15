//
//  NoteCustomCell.h
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskC+CoreDataClass.h"

@interface NoteCustomCell : UITableViewCell

-(NoteCustomCell *)loadCell:(NoteCustomCell *)cell task:(TaskC *)task;
@property (nonatomic, copy) void(^actionNoteChecked)(void);

@end
