//
//  AlarmTableViewCell.h
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Task.h"


@interface AlarmTableViewCell : UITableViewCell
-(AlarmTableViewCell *)loadCell:(AlarmTableViewCell *)cell
                           task:(Task *)task
                      indexPath:(NSIndexPath *)indexPath;

@property (nonatomic, copy) void(^actionAlarmOn)(void);
@property (nonatomic, copy) void(^actionAlarmOff)(void);

@end
