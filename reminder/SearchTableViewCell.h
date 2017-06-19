//
//  SearchTableViewCell.h
//  reminder
//
//  Created by Nikola on 6/19/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskC+CoreDataClass.h"


@protocol SearchCellDelegate <NSObject>

-(void)openTask:(TaskC *)task;


@end

@interface SearchTableViewCell : UITableViewCell

-(SearchTableViewCell *)loadCell:(SearchTableViewCell *)cell task:(TaskC *)task;
@property (weak, nonatomic) id<SearchCellDelegate> delegate;
@end
