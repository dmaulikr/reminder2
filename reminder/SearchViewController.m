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

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,UISearchBarDelegate, UIScrollViewDelegate, UISearchDisplayDelegate, UISearchControllerDelegate>



@property (strong, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *tableViewSearch;
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UISearchBar *srchBar;
@property (weak, nonatomic) IBOutlet UIView *vResults;
@property (weak, nonatomic) IBOutlet UILabel *lblResultsFound;

@end

@implementation SearchViewController

- (void)viewDidLoad
{
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        Singleton *instance = [Singleton sharedInstance];
        PopTaskViewController *vc = [instance.storyBoard instantiateViewControllerWithIdentifier:@"popTask"];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        TaskC *task = [self.searchResults objectAtIndex:indexPath.row];
        vc.taskC = task;
        [self presentViewController:vc animated:YES completion:NULL];
}

@end
