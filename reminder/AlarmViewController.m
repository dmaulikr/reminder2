//
//  AlarmViewController.m
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AlarmViewController.h"
#import "AlarmTableViewCell.h"
#import "Task.h"

@interface AlarmViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewAlarm;

@end

@implementation AlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewAlarm.delegate = self;
    self.tableViewAlarm.dataSource = self;
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addAlarm:(id)sender {
    
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.taskOpened.alarmsArray count];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifire = @"alarmCell";
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    cell = [cell loadCell:cell task:self.taskOpened indexPath:indexPath];
    
    
    
    cell.actionAlarmOn = ^
    {
        Alarm *alarm = [self.taskOpened.alarmsArray objectAtIndex:indexPath.row];
        for (Alarm *alarmSwitched in self.taskOpened.alarmsArray)
        {
            if ([alarmSwitched isEqual:alarm])
            {
                alarmSwitched.isSet = NO;
            }
        }
        [self.tableViewAlarm reloadData];
        
    };
    cell.actionAlarmOff = ^
    {
        Alarm *alarm = [self.taskOpened.alarmsArray objectAtIndex:indexPath.row];
        for (Alarm *alarmSwitched in self.taskOpened.alarmsArray)
        {
            if ([alarmSwitched isEqual:alarm])
            {
                alarmSwitched.isSet = YES;
            }
        }
        [self.tableViewAlarm reloadData];
    };
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
@end
