//
//  AlarmTableViewCell.m
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AlarmTableViewCell.h"
#import "Alarm.h"
#import "Colors.h"
#import "TaskC+CoreDataClass.h"
#import "AlarmC+CoreDataClass.h"
#import "Date.h"

@interface AlarmTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblAlarmDat;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;
@property (weak, nonatomic) IBOutlet UILabel *lblAlarmType;


@end

@implementation AlarmTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadCell:(AlarmTableViewCell *)cell
{
    
}
-(AlarmTableViewCell *)loadCell:(AlarmTableViewCell *)cell
                           task:(TaskC *)task
                      indexPath:(NSIndexPath *)indexPath
{
    
    NSArray *alarmsArray = [task.alarms allObjects];
    AlarmC *alarm = [alarmsArray objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [Date getDateForrmater:@"alarm"];
    
    self.lblAlarmType.text = alarm.alarmTitle;
    self.lblAlarmDat.text = [formatter stringFromDate:alarm.alarmDate];
    
    if (alarm.isSet == YES)
    {
        [self.alarmSwitch setOn:YES];
        self.lblAlarmDat.textColor = [UIColor blackColor];
        self.lblAlarmType.textColor = [UIColor blackColor];
    }
    else
    {
        [self.alarmSwitch setOn:NO];
        self.lblAlarmDat.textColor = [Colors lightGray];
        self.lblAlarmType.textColor = [Colors lightGray];
    }
    return cell;
}
- (IBAction)alarmSwitchAction:(id)sender
{
    if ([self.alarmSwitch isOn])
    {
        if (self.actionAlarmOff)
        {
            self.actionAlarmOff();
        }
    }
    else
    {
        if (self.actionAlarmOn)
        {
            self.actionAlarmOn();
        }
    }
}

@end
