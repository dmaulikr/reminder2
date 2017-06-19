//
//  FavoritesViewController.m
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "FavoritesViewController.h"
#import "TaskC+CoreDataClass.h"
#import "NoteCustomCell.h"
#import "Singleton.h"
#import "DataSource.h"
#import "PopTaskViewController.h"

@interface FavoritesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *dataSourceFavorites;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFavorites;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceFavorites = [DataSource getDataSourceWithName:@"favorites"];
    self.tableViewFavorites.delegate = self;
    self.tableViewFavorites.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskUpdated) name:@"dataSourceUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChecked) name:@"taskChecked" object:nil];
    self.tableViewFavorites.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceFavorites count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"noteCustomCell";
    TaskC *task = [self.dataSourceFavorites objectAtIndex:indexPath.row];
    
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
        self.dataSourceFavorites = [DataSource getDataSourceWithName:@"favorites"];
        [self.tableViewFavorites reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Singleton *instance = [Singleton sharedInstance];
    PopTaskViewController *vc = [instance.storyBoard instantiateViewControllerWithIdentifier:@"popTask"];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    TaskC *task = [self.dataSourceFavorites objectAtIndex:indexPath.row];
    vc.taskC = task;
    [self presentViewController:vc animated:YES completion:NULL];
}
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        TaskC *task = [self.dataSourceFavorites objectAtIndex:indexPath.row];
        [DataSource updateDataSourceWithOperation:@"deleteTask" task:task
                                            alarm:nil
                                       attachment:nil
                                         location:nil];
        [DataSource getDataSourceByDates];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
        [self.tableViewFavorites reloadData];
        
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
    self.dataSourceFavorites = [DataSource getDataSourceWithName:@"favorites"];
    NSLog(@"favorites triggerd");
    [self.tableViewFavorites reloadData];
}
-(void)updateChecked
{
    self.dataSourceFavorites = [DataSource getDataSourceWithName:@"favorites"];
    [self.tableViewFavorites reloadData];
}
@end
