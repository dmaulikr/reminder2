//
//  MainViewController.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "MainViewController.h"
#import "Singleton.h"
#import "AddViewController.h"
#import "PopTaskViewController.h"
#import "NoteCell.h"
#import "TaskC+CoreDataClass.h"
#import "NoteCustomCell.h"
#import "DataSource.h"
#import "Date.h"

@interface MainViewController ()  <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (strong, nonatomic) NSArray *datesKeys;
@property (strong, nonatomic) NSMutableDictionary *arrayByDates;
@property (strong, nonatomic) Singleton *sharedInstance;
@property (strong, nonatomic) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *btnNextDate;
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousDate;
@property(nonatomic, assign) int currentIndex;
@property(nonatomic, assign) int lastIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedDate;
- (IBAction)nextDateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *previousDateAction;

- (IBAction)previousDateAction:(id)sender;
@end

@implementation MainViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle)];
    leftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftRecognizer setNumberOfTouchesRequired:1];
    
    [self.view addGestureRecognizer:rightRecognizer];
    [self.view addGestureRecognizer:leftRecognizer];
    
    self.sharedInstance = [Singleton sharedInstance];
    
    NSMutableDictionary *byDates = [DataSource getDataSourceByDates];
    
    self.datesKeys = [byDates allKeys];
    self.arrayByDates = byDates;
    self.datesKeys = [self sortDates:self.datesKeys];
    [self loadLastDate];
    self.selectedDate = [self.datesKeys lastObject];
    NSString *dateString = [Date timeSince:self.selectedDate];
    self.lblSelectedDate.text = dateString;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.dataSource2 = [DataSource getDataSourceByDates];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskUpdated) name:@"dataSourceUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChecked) name:@"taskChecked" object:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayByDate = [self.dataSource2 objectForKey:self.selectedDate];
    self.lastIndex = (int)[self.datesKeys count];
    self.btnPreviousDate.hidden = NO;
    self.tableView.hidden = NO;

    if (self.currentIndex == 0)
    {
        self.btnPreviousDate.hidden = YES;
    }
    if (self.currentIndex == self.lastIndex - 1)
    {
        self.btnNextDate.hidden = YES;
    }
    if (self.lastIndex == 1)
    {
        self.btnPreviousDate.hidden = YES;
        self.btnNextDate.hidden = YES;
    }
        switch ([arrayByDate count])
    {
        case 0:            
            if (self.currentIndex < self.lastIndex)
            {
                [self nextDateAction:self];
            }
            if (self.currentIndex > 0)
            {
                [self previousDateAction:self];
            }
            break;
    }
    if ([self.datesKeys count] == 0)
    {
        self.lblSelectedDate.text = @"No tasks";
        self.tableView.hidden = YES;
    }
    return [arrayByDate count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"noteCustomCell";

    NSArray *arr = [self.dataSource2 objectForKey:self.selectedDate];
    TaskC *task = [arr objectAtIndex:indexPath.row];

    NoteCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CustomNoteCell" bundle:nil] forCellReuseIdentifier:MyIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    }
    cell = [cell loadCell:cell task:task];
    cell.actionNoteChecked = ^
    {
        [DataSource updateDataSourceWithOperation:@"taskDone"
                                             task:task
                                            alarm:nil attachment:nil location:nil];
        self.dataSource2 = [DataSource getDataSourceByDates];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
        [self.tableView reloadData];
    };
    return cell;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)tableView:(UITableView *)tableView
                didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopTaskViewController *vc = [self.sharedInstance.storyBoard instantiateViewControllerWithIdentifier:@"popTask"];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    NSArray *arr = [self.dataSource2 objectForKey:self.selectedDate];
    TaskC *task = [arr objectAtIndex:indexPath.row];
    vc.taskC = task;
    [self presentViewController:vc animated:YES completion:NULL];
}
-(CGFloat)tableView:(UITableView *)tableView
                    heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (BOOL)tableView:(UITableView *)tableView
                    canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView
                    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSArray *arr = [self.dataSource2 objectForKey:self.selectedDate];
        TaskC *task = [arr objectAtIndex:indexPath.row];
        [DataSource updateDataSourceWithOperation:@"deleteTask" task:task
                                            alarm:nil
                                       attachment:nil
                                         location:nil];
        [DataSource getDataSourceByDates];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
        [self.tableView reloadData];
        
    }
}
-(void)checkDone:(UIButton *)btn
{
    int tag = (int)btn.tag;
    NSArray *arr = [self.dataSource2 objectForKey:self.selectedDate];
    Task *task = [arr objectAtIndex:tag];
    if (task.isDone == YES)
    {
        task.isDone = NO;
    }else
    {
        task.isDone = YES;
    }
    [self.sharedInstance update:task];
    self.dataSource = [self.sharedInstance loadAllTasks];
    btn.tag = 4;
    [self.tableView reloadData];
}
- (IBAction)nextDateAction:(id)sender
{
    if (self.currentIndex < [self.datesKeys count])
    {
        self.currentIndex ++;
    }
    NSLog(@"current index -- > %i", self.currentIndex);
    if (self.currentIndex < [self.datesKeys count])
    {
        NSDate *selectedDate = [self.datesKeys objectAtIndex:self.currentIndex];
        self.selectedDate = selectedDate;
        NSString *dateString = [Date timeSince:self.selectedDate];
        self.lblSelectedDate.text = dateString;
        [self.tableView reloadData];
    }
}
- (IBAction)previousDateAction:(id)sender
{
    if (self.currentIndex > 0)
    {
        self.currentIndex --;
        NSLog(@"current index -- > %i", self.currentIndex);
    }
    self.btnNextDate.hidden = NO;
    if (self.currentIndex >= 0)
    {
        NSDate *selectedDate = [self.datesKeys objectAtIndex:self.currentIndex];
        self.selectedDate = selectedDate;
        NSString *dateString = [Date timeSince:self.selectedDate];
        self.lblSelectedDate.text = dateString;
        [self.tableView reloadData];
    }
}
-(void)loadLastDate
{
    NSDate *selectedDate = [self.datesKeys lastObject];
    NSInteger index = [self.datesKeys count];
    int indexInt = (int)index;
    self.currentIndex = indexInt - 1;
    NSLog(@"current index -- > %i", self.currentIndex);
    self.selectedDate = selectedDate;
    NSString *dateString = [Date timeSince:self.selectedDate];
    self.lblSelectedDate.text = dateString;

}
-(NSArray *)sortDates: (NSArray *)array
{
    NSArray *sorted = [self.datesKeys sortedArrayUsingComparator:^(id obj1, id obj2)
    {
        NSDate *d1 = obj1;
        NSDate *d2 = obj2;
        if (d1>d2)
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        else
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedDescending;
    }];
    return sorted;
}
-(void)loadDelete
{
    NSMutableDictionary *byDates = [DataSource getDataSourceByDates];
    self.datesKeys = [byDates allKeys];
    self.arrayByDates = [DataSource getDataSourceByDates];
    self.datesKeys = [self sortDates:self.datesKeys];
    self.currentIndex = (int)[self.datesKeys count];
    [self.tableView reloadData];
}
-(void)loadAdd
{
    NSMutableDictionary *byDates = [DataSource getDataSourceByDates];
    self.datesKeys = [byDates allKeys];
    self.arrayByDates = [DataSource getDataSourceByDates];
    self.datesKeys = [self sortDates:self.datesKeys];
    if (self.currentIndex < [self.datesKeys count] -1)
    {
        [self nextDateAction:self];
    }
    [self.tableView reloadData];
}
-(void)rightSwipeHandle
{
    [self nextDateAction:self];
}
-(void)leftSwipeHandle
{
    [self previousDateAction:self];
}
-(void)noteCheckedAction: (NSIndexPath *)indexPath
{
    [self.delegate taskChecked:indexPath];
}
-(void)taskUpdated
{
    Singleton *instance = [Singleton sharedInstance];
    [instance coreDataUpdated];
    self.dataSource2 = [DataSource getDataSourceByDates];
    NSLog(@"main triggerd");
    [self loadAdd];
}
-(void)updateChecked
{
    self.dataSource2 = [DataSource getDataSourceByDates];
    [self loadAdd];
}
@end
