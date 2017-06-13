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
                          completionHandler:^(BOOL granted, NSError * _Nullable error)
    {
                              if (!granted) {
                                  NSLog(@"Something went wrong");
                              }
                          }];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings)
    {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized)
        {
            // Notifications not allowed
        }
    }];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];
    
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error)
    {
        if (error != nil)
        {
            NSLog(@"Something went wrong: %@",error);
        }
    }];
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
    
    NSManagedObjectContext *context = [instance.coreData managedObjectContext];
    
    NSManagedObject *taskObject = self.taskCOpened;
    
    UITableView *tableView = self.tableViewAlarm;
    
    self.actionDateDone = ^
    {
        
        NSEntityDescription *entityAlarm = [NSEntityDescription entityForName:@"AlarmC" inManagedObjectContext:context];
        NSManagedObject *newAlarm = [[NSManagedObject alloc] initWithEntity:entityAlarm insertIntoManagedObjectContext:context];
        
        [newAlarm setValue:@"datePicker" forKey:@"alarmTitle"];
        [newAlarm setValue:datePicker.date forKey:@"alarmDate"];
        
        NSNumber *isSet = [[NSNumber alloc] initWithBool:YES];
        
        [newAlarm setValue:isSet forKey:@"isSet"];
        
        NSMutableSet *alarms = [taskObject mutableSetValueForKey:@"alarms"];
        [alarms addObject:newAlarm];

        [instance.coreData saveContext];
        [tableView reloadData];

    };
    
}

@end
