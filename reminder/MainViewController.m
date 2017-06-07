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
#include "IndexPath.h"


@interface MainViewController ()  <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (strong, nonatomic) NSArray *datesKeys;
@property (strong, nonatomic) NSMutableDictionary *arrayByDates;
@property (strong, nonatomic) Singleton *sharedInstance;
@property (strong, nonatomic) NSString *selectedDate;
@property (weak, nonatomic) IBOutlet UIButton *btnNextDate;
@property (weak, nonatomic) IBOutlet UIButton *btnPreviousDate;

@property(nonatomic, assign) int currentIndex;

@property (weak, nonatomic) IBOutlet UILabel *lblSelectedDate;
- (IBAction)nextDateAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *previousDateAction;

- (IBAction)previousDateAction:(id)sender;

- (IBAction)checkAction:(id)sender;

@end


@implementation MainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sharedInstance = [Singleton sharedInstance];
    
    self.datesKeys = [self.sharedInstance.tasksByDates allKeys];
    self.arrayByDates = self.sharedInstance.tasksByDates;
    
    [self loadLastDate];
    
    
    self.selectedDate = @"13-05-17";
    
    self.lblSelectedDate.text = self.selectedDate;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    self.dataSource2 = [self.sharedInstance loadAll];
    

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewScreen)];
    
    tapGesture.numberOfTapsRequired = 1;
    self.imgAdd.userInteractionEnabled = YES;
    [self.imgAdd addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadTable" object:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arrayByDate = [self.dataSource2 objectForKey:self.selectedDate];
    
//    return [self.dataSource count];
    return [arrayByDate count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"taskCell";
    
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    UIButton *checkBtn =  (UIButton *)[cell viewWithTag:4];
    
    if ([self.dataSource2 count] >0)
    {
        NSArray *arr = [self.dataSource2 objectForKey:self.selectedDate];
        
        Task *task = [arr objectAtIndex:indexPath.row];
        cell = [NoteCell loadCell:cell task:task];
        
        if (task.isDone == YES)
        {
            UIImage *btnImage = [UIImage imageNamed:@"checkRed.png"];
            [checkBtn setImage:btnImage forState:UIControlStateNormal];
        }else
        {
            UIImage *btnImage = [UIImage imageNamed:@"circle.png"];
            [checkBtn setImage:btnImage forState:UIControlStateNormal];
        }
        
    }
        checkBtn.tag = indexPath.row;
        [checkBtn addTarget:self
                     action:@selector(checkDone:)
         forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"popTask"];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    NSArray *arr = [self.dataSource2 objectForKey:self.selectedDate];
    
    
    Task *task = [arr objectAtIndex:indexPath.row];

    
    vc.task = task;

    [self presentViewController:vc animated:YES completion:NULL];
    
}
-(void)addNewScreen
{
    AddViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"addNewController"];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    [self presentViewController:vc animated:YES completion:NULL];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
-(void)reloadTable
{
    [self.tableView reloadData];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Task *task = [self.dataSource objectAtIndex:indexPath.row];
        
        [self.sharedInstance deleteTask:task];
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
    self.currentIndex ++;
    self.btnPreviousDate.hidden = NO;
    
    if (self.currentIndex == [self.datesKeys count])
    {
        self.btnNextDate.hidden = YES;
    }
    if (self.currentIndex < [self.datesKeys count])
    {
        NSString *selectedDate = [self.datesKeys objectAtIndex:self.currentIndex];
        self.selectedDate = selectedDate;
        self.lblSelectedDate.text = selectedDate;
        [self.tableView reloadData];
    }
}
- (IBAction)previousDateAction:(id)sender
{
    self.currentIndex --;
    
    self.btnNextDate.hidden = NO;
    
    if (self.currentIndex >= 0)
    {
        if (self.currentIndex == 0)
        {
            self.btnPreviousDate.hidden = YES;
        }
        NSString *selectedDate = [self.datesKeys objectAtIndex:self.currentIndex];
        self.selectedDate = selectedDate;
        self.lblSelectedDate.text = selectedDate;
        [self.tableView reloadData];
    }
}
-(void)loadLastDate
{
    NSString *selectedDate = [self.datesKeys lastObject];
    NSInteger index = [self.datesKeys count];
    int indexInt = (int)index;
    
    self.currentIndex = indexInt - 1;
    
    self.btnNextDate.hidden = YES;
    
    self.selectedDate = selectedDate;
    
    self.lblSelectedDate.text = selectedDate;

}
@end
