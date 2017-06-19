//
//  AllTasksViewController.m
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AllTasksViewController.h"
#import "NoteCell.h"
#import "Singleton.h"
#import "TaskC+CoreDataClass.h"
#import "AllNotesCell.h"
#import "NoteCustomCell.h"
#import "PopTaskViewController.h"
#import "DataSource.h"

@interface AllTasksViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewAllTasks;
@property (strong, nonatomic) NSMutableArray *dataSourceAll;
@end

@implementation AllTasksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableViewAllTasks.delegate = self;
    self.tableViewAllTasks.dataSource = self;
    self.dataSourceAll = [DataSource getDataSourceWithName:@"allTasks"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskUpdated) name:@"dataSourceUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChecked) name:@"taskChecked" object:nil];
    self.tableViewAllTasks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceAll count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *MyIdentifier = @"noteCustomCell";
    TaskC *task = [self.dataSourceAll objectAtIndex:indexPath.row];

    NoteCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomNoteCell" bundle:nil] forCellReuseIdentifier:MyIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    }
    cell = [cell loadCell:cell task:task];

    cell.actionNoteChecked = ^
    {
        [DataSource updateDataSourceWithOperation:@"taskDone"
                                             task:task
                                            alarm:nil attachment:nil location:nil];
        self.dataSourceAll = [DataSource getDataSourceWithName:@"allTasks"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
        [self.tableViewAllTasks reloadData];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Singleton *instance = [Singleton sharedInstance];
    PopTaskViewController *vc = [instance.storyBoard instantiateViewControllerWithIdentifier:@"popTask"];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    TaskC *task = [self.dataSourceAll objectAtIndex:indexPath.row];
    vc.taskC = task;
    [self presentViewController:vc animated:YES completion:NULL];
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {

        TaskC *task = [self.dataSourceAll objectAtIndex:indexPath.row];
        [DataSource updateDataSourceWithOperation:@"deleteTask" task:task
                                            alarm:nil
                                       attachment:nil
                                         location:nil];
        [DataSource getDataSourceByDates];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
        [self.tableViewAllTasks reloadData];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView
                heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
-(void)taskUpdated
{
    Singleton *instance = [Singleton sharedInstance];
    [instance coreDataUpdated];
   
    self.dataSourceAll = [DataSource getDataSourceWithName:@"allTasks"];
    NSLog(@"allTasks triggerd");
    [self.tableViewAllTasks reloadData];
}
-(void)updateChecked
{
    self.dataSourceAll = [DataSource getDataSourceWithName:@"allTasks"];
    [self.tableViewAllTasks reloadData];
}

@end
