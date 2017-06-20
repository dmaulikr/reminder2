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
#import "Singleton.h"
#import <UserNotificationsUI/UserNotificationsUI.h>
#import "AlarmC+CoreDataClass.h"
#import "PopTaskViewController.h"
#import "Date.h"

@interface AlarmViewController () <UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableViewAlarm;
@property (strong, nonatomic) UNUserNotificationCenter *center;
@property (nonatomic, assign) NSTimeInterval countDownInterval;
@end

@implementation AlarmViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableViewAlarm.delegate = self;
    self.tableViewAlarm.dataSource = self;
    self.tableViewAlarm.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.center.delegate = self;
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addAlarm:(id)sender
{
    [self datePicker:self];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *myArray = [self.taskCOpened.alarms allObjects];
    return [myArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifire = @"alarmCell";
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire];
    cell = [cell loadCell:cell task:self.taskCOpened indexPath:indexPath];
    
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

- (void)changeDate:(UIDatePicker *)sender
{
    NSLog(@"New Date: %@", sender.date);
    
}

- (void)removeViews:(id)object
{
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    
    if (self.actionDateDone)
    {
        self.actionDateDone();
    }
}
-(void)dismissDatePickerTap
{
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];

}
-(void)datePicker:(id)sender
{
    if ([self.view viewWithTag:9])
    {
        return;
    }
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, self.view.bounds.size.width, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePickerTap)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    doneButton.tintColor = [UIColor blackColor];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    datePicker.backgroundColor = [UIColor whiteColor];
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
    Singleton *instance = [Singleton sharedInstance];
    NSManagedObject *taskObject = self.taskCOpened;
    UITableView *tableView = self.tableViewAlarm;
    NSDate *currentDate = [NSDate new];

    NSDate *someDateInUTC = currentDate;
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
    datePicker.date = [datePicker.date dateByAddingTimeInterval:timeZoneSeconds];
    
    self.actionDateDone = ^
    {
        [instance.coreData
         addAlarmWithTitle:@"alarm" time:datePicker.date
                                         set:YES managedObject:taskObject];
        NSTimeInterval interval = [datePicker.date timeIntervalSinceDate:dateInLocalTimezone];
        NSLog(@"picekr date : %@", datePicker.date);
        UNMutableNotificationContent *localNotification = [UNMutableNotificationContent new];
        localNotification.title = [NSString localizedUserNotificationStringForKey:@"Time for a run!" arguments:nil];
        localNotification.body = [NSString localizedUserNotificationStringForKey:@"BTW, running late to happy hour does not count as workout" arguments:nil];
        UNNotificationSound *sound = [UNNotificationSound soundNamed:@"sound.aiff"];
        localNotification.sound = sound;
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Time for a run!" content:localNotification trigger:trigger];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"Notification created");
            NSLog(@"for time interval : %f", interval);
        }];
        [tableView reloadData];
    };
}

- (void)takeActionWithLocalNotification:(UNNotification *)localNotification
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:localNotification.request.content.title message:localNotification.request.content.body preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ok");
    }];
    [alertController addAction:ok];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:^{
        }];
    });
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Notification alert" message:@"This app just sent you a notification, do you want to see it?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ignore = [UIAlertAction actionWithTitle:@"IGNORE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"ignore");
    }];
    UIAlertAction *see = [UIAlertAction actionWithTitle:@"SEE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takeActionWithLocalNotification:notification];
    }];
    
    [alertController addAction:ignore];
    [alertController addAction:see];
    
    [self presentViewController:alertController animated:YES completion:^{
    }];
}
- (void)userSelectTime:(UIDatePicker *)sender
{
    
    self.countDownInterval = (NSTimeInterval )sender.countDownDuration;
    
}
@end
