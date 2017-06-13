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
#import <UserNotifications/UserNotifications.h>

#import <UserNotificationsUI/UserNotificationsUI.h>

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
                [self setNotification];
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
-(void)setNotification
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = @"Don't forget";
    content.body = @"Buy some milk";
    content.sound = [UNNotificationSound defaultSound];
    
//    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10 repeats:NO];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:30];
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                     components:NSCalendarUnitYear +
                                     NSCalendarUnitMonth + NSCalendarUnitDay +
                                     NSCalendarUnitHour + NSCalendarUnitMinute +
                                     NSCalendarUnitSecond fromDate:date];
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
    
    NSString *identifier = @"UYLLocalNotification";
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    
    [center requestAuthorizationWithOptions:options
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              if (!granted) {
                                  NSLog(@"Something went wrong");
                              }
                          }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
            // Notifications not allowed
        }
    }];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
    }
@end
