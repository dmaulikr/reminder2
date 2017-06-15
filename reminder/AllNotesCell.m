//
//  AllNotesCell.m
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AllNotesCell.h"
#import "Colors.h"
#import "AlarmC+CoreDataClass.h"
#import "Date.h"

@interface AllNotesCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblNoteTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteDate;

@property (weak, nonatomic) IBOutlet UIButton *btnNoteChecked;

@property (weak, nonatomic) IBOutlet UIView *vRed;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckedAction;

@end

@implementation AllNotesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(AllNotesCell *)loadCell:(AllNotesCell *)cell task:(TaskC *)task
{
    if (task.isDone == YES)
    {
        self.lblNoteTitle.textColor = [Colors gray];
        self.lblNoteDate.textColor = [Colors gray];
        cell.backgroundColor = [Colors lightGray];
    }
    else
    {
        self.lblNoteTitle.textColor = [UIColor blackColor];
        self.lblNoteDate.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (task.isLiked == YES) {
        self.vRed.backgroundColor = [Colors redColor];
    }
    else
    {
        self.vRed.backgroundColor = [UIColor whiteColor];
    }
    int count = 0;
    
    NSArray *alarmsArray = [task.alarms allObjects];
    for (AlarmC *alarm in alarmsArray)
    {
        
        if (alarm.isSet == YES)
        {
            count ++;
        }
    }
//    if (count > 0)
//    {
//        self.imgAlarm.hidden = NO;
//    }
//    else
//    {
//        self.imgAlarm.hidden = YES;
//    }
//    if ([task.attachments count] > 0)
//    {
//        self.imgAttachment.hidden = NO;
//    }
//    else
//    {
//        self.imgAttachment.hidden = YES;
//    }
    NSDateFormatter *formatter = [Date getDateForrmater:@"allNotesCell"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    NSString *noteTitle = task.title;
    [self.lblNoteTitle setText:noteTitle];
    [self.lblNoteDate setText:stringFromDate];
    
    self.btnNoteChecked =  (UIButton *)[cell viewWithTag:4];
    
    UIImage *btnImage = [[UIImage alloc] init];
    
    if (task.isDone == YES)
    {
        btnImage = [UIImage imageNamed:@"checkRedGreen.png"];
        [self.btnNoteChecked setImage:btnImage forState:UIControlStateNormal];
    }
    else
    {
        btnImage = [UIImage imageNamed:@"circle.png"];
        [self.btnNoteChecked setImage:btnImage forState:UIControlStateNormal];
    }

    return cell;
}

@end
