//
//  SearchTableViewCell.m
//  reminder
//
//  Created by Nikola on 6/19/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "Date.h"
#import "PopTaskViewController.h"
#import "Singleton.h"

@interface SearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btnHidden;
@property (strong, nonatomic) TaskC *taskSearchCell;
- (IBAction)btnHiddenAction:(id)sender;

@end
@implementation SearchTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(SearchTableViewCell *)loadCell:(SearchTableViewCell *)cell task:(TaskC *)task
{
    NSDateFormatter *formatter = [Date getDateForrmater:@"allNotesCell"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    self.lblTitle.text = task.title;
    self.lblDate.text = stringFromDate;
    self.taskSearchCell = task;
    return cell;
}

- (IBAction)btnHiddenAction:(id)sender
{
    [self.delegate openTask:self.taskSearchCell];
}
@end
