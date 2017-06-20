//
//  StartViewController.m
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "StartViewController.h"
#import "Singleton.h"
#import "AddViewController.h"
#import "PopTaskViewController.h"
#import "AddViewController.h"
#import "DataSource.h"


NSInteger selectedIndexBtn = 0;

@interface StartViewController () <AddNewControllerDelegate>

@property (strong, nonatomic) UIViewController *byDatesViewController;
@property (strong, nonatomic) UIViewController *allTasksViewController;
@property (strong, nonatomic) UIViewController *favoritesViewController;
@property (strong, nonatomic) UIViewController *searchViewController;
@property (strong, nonatomic) NSMutableArray *viewControllersArray;
@property (weak, nonatomic) IBOutlet UIView *vMainControllerView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnsArray;
@property (weak, nonatomic) IBOutlet UIButton *btnAllTasks;

- (IBAction)addBtnPressedAction:(id)sender;

- (IBAction)toggleViewsAction:(id)sender;

@end

@implementation StartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewControllersArray = [[NSMutableArray alloc] init];
    
    Singleton *instance = [Singleton sharedInstance];
    UIStoryboard *storyBoard = instance.storyBoard;
    
    self.byDatesViewController = [storyBoard instantiateViewControllerWithIdentifier:@"mainVC"];
    self.allTasksViewController = [storyBoard instantiateViewControllerWithIdentifier:@"allTasks"];
    self.favoritesViewController = [storyBoard instantiateViewControllerWithIdentifier:@"favoritesVC"];
    self.searchViewController = [storyBoard instantiateViewControllerWithIdentifier:@"searchVC"];
    
    
    [self.viewControllersArray addObject:self.allTasksViewController];
    [self.viewControllersArray addObject:self.byDatesViewController];
    [self.viewControllersArray addObject:self.favoritesViewController];
    [self.viewControllersArray addObject:self.searchViewController];
    
    StartViewController *vc = self.viewControllersArray[0];
    vc.view.frame = self.vMainControllerView.bounds;
    [self.vMainControllerView addSubview:vc.view];
    
    [self.btnAllTasks setImage:[UIImage imageNamed:@"taskIconPressed.png"] forState:UIControlStateNormal];

}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)addBtnPressedAction:(id)sender
{
    Singleton *instance = [Singleton sharedInstance];
    PopTaskViewController *vc = [instance.storyBoard instantiateViewControllerWithIdentifier:@"popTask"];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [self presentViewController:vc animated:YES completion:NULL];

}

- (IBAction)toggleViewsAction:(UIButton *)sender
{
    selectedIndexBtn = sender.tag;
    
    for (UIButton *button in self.btnsArray)
    {
        if (button.tag != sender.tag)
        {
            switch (button.tag)
            {
                case 0:
                    [button setImage:[UIImage imageNamed:@"taskIcon.png"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [button setImage:[UIImage imageNamed:@"calendar.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [button setImage:[UIImage imageNamed:@"favoritesIcon.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [button setImage:[UIImage imageNamed:@"searchIcon.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (button.tag)
            {
                case 0:
                    [button setImage:[UIImage imageNamed:@"taskIconPressed.png"] forState:UIControlStateNormal];
                    break;
                case 1:
                    [button setImage:[UIImage imageNamed:@"calendarPressed.png"] forState:UIControlStateNormal];
                    break;
                case 2:
                    [button setImage:[UIImage imageNamed:@"favoritesIconPressed.png"] forState:UIControlStateNormal];
                    break;
                case 3:
                    [button setImage:[UIImage imageNamed:@"searchIconPressed.png"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
        }
    }
    NSLog(@"selected indes -- > %li", (long)selectedIndexBtn);
    StartViewController *vc = self.viewControllersArray[selectedIndexBtn];
    vc.view.frame = self.vMainControllerView.bounds;
    [self.vMainControllerView addSubview:vc.view];
}
-(void)newTaskAdded
{
    //update datasource
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
    
}
@end
