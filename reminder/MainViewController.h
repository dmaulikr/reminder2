//
//  MainViewController.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCell.h"
#import "TasksUpdater.h"
#import "PopTaskViewController.h"


@protocol MainViewControllerDelegate <NSObject, PopViewControllerDellegate>

@optional
-(void)attachmentsBrnPressed;
-(void)taskChecked: (NSIndexPath *)indexPath;
//-(void)taskUpdated;

@end


@interface MainViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableDictionary *dataSource2;

@property (weak, nonatomic) id<MainViewControllerDelegate> delegate;



@end



