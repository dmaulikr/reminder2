//
//  MainViewController.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCell.h"


@interface MainViewController : UIViewController



@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdd;

@property (strong, nonatomic) NSMutableDictionary *dataSource2;


@end



