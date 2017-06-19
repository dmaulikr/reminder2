//
//  SearchTableViewCell.m
//  reminder
//
//  Created by Nikola on 6/19/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "Date.h"
@interface SearchTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;

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
    return cell;
}

@end
