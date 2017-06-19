//
//  SearchViewController.m
//  reminder
//
//  Created by Nikola on 6/19/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "SearchViewController.h"
#import "Singleton.h"
#import "SearchTableViewCell.h"
#import "PopTaskViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,UISearchBarDelegate, UIScrollViewDelegate, UISearchDisplayDelegate, UISearchControllerDelegate, UIGestureRecognizerDelegate, SearchCellDelegate>

@property (strong, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UISearchBar *srchBar;
@property (weak, nonatomic) IBOutlet UIView *vResults;
@property (weak, nonatomic) IBOutlet UILabel *lblResultsFound;
@property (weak, nonatomic) IBOutlet UIImageView *imgSearchScope;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintYPosotion;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBarShouldEndEditing:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    tap.cancelsTouchesInView = NO;
    self.tableViewSearch.layer.zPosition = 1;
    
    self.srchBar.delegate = self;
    self.tableViewSearch.delegate = self;
    self.tableViewSearch.dataSource = self;
    self.searchResults = [[NSArray alloc] init];
    Singleton *instance = [Singleton sharedInstance];
    self.dataArray = instance.tasksArray;
    self.srchBar.tintColor = [UIColor whiteColor];
    [self.srchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [self.srchBar setBackgroundImage:[UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])]];
    self.tableViewSearch.delegate = self;
    self.tableViewSearch.dataSource = self;
    self.tableViewSearch.hidden = YES;
    self.vResults.hidden = YES;
    self.imgSearchScope.center = self.view.center;
    [self.srchBar becomeFirstResponder];
    self.tableViewSearch.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = (int)[self.searchResults count];
    self.lblResultsFound.text = [NSString stringWithFormat:@"%i results found", number];
    return number;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell *cell = [self.tableViewSearch dequeueReusableCellWithIdentifier:@"cellSerach" forIndexPath:indexPath];
    TaskC *task = (TaskC *)[self.searchResults objectAtIndex:indexPath.row];
    [cell loadCell:cell task:task];
    cell.delegate = self;
    return cell;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
 
    if(searchText.length > 0)
    {
        NSString *searchString = searchText;
        if (!searchString.length)
        {
            
        }
        else
        {
            Singleton *instance = [Singleton sharedInstance];
            NSString *strippedString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"TaskC" inManagedObjectContext:instance.coreData.managedObjectContext];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@", strippedString];
            [fetchRequest setPredicate:predicate];
            NSError *error;
            self.searchResults = [self.dataArray filteredArrayUsingPredicate:predicate];
            self.searchResults = [instance.coreData.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            self.tableViewSearch.hidden = NO;
            self.vResults.hidden = NO;
        }
        [self.tableViewSearch reloadData];
    }
    else
    {
        self.searchResults = nil;
        self.tableViewSearch.hidden = YES;
        self.vResults.hidden = YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.srchBar resignFirstResponder];
    self.srchBar.text = @"";
    self.searchResults = nil;
    self.tableViewSearch.hidden = YES;
    self.vResults.hidden = YES;
    
    return YES;
}

-(void)moveSearchScopeUp
{
    [self.view layoutIfNeeded];
    self.constraintYPosotion.constant += -40;
    [UIView animateWithDuration:0.4 animations:^
    {
        [self.view layoutIfNeeded]; }
     ];
}
-(void)moveSearchScopeDown
{
    [self.view layoutIfNeeded];
    self.constraintYPosotion.constant = 0;
    [UIView animateWithDuration:0.4 animations:^
    {
        [self.view layoutIfNeeded]; }
     ];
}
- (void)keyboardDidShow: (NSNotification *) notif
{
    [self moveSearchScopeUp];
}

- (void)keyboardDidHide: (NSNotification *) notif
{
    [self moveSearchScopeDown];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view class] == [UIButton class])
    {
        return NO;
    }
    return YES;
}
-(void)openTask:(TaskC *)task
{
    Singleton *instance = [Singleton sharedInstance];
    PopTaskViewController *vc = [instance.storyBoard instantiateViewControllerWithIdentifier:@"popTask"];
    vc.taskC = task;
    [self presentViewController:vc animated:YES completion:NULL];
}
@end
