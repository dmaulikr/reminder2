//
//  SearchTableViewCell.h
//  reminder
//
//  Created by Nikola on 6/19/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskC+CoreDataClass.h"

@interface SearchTableViewCell : UITableViewCell

-(SearchTableViewCell *)loadCell:(SearchTableViewCell *)cell task:(TaskC *)task;

@end
