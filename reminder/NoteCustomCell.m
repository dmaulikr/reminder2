//
//  NoteCustomCell.m
//  reminder
//
//  Created by Nikola on 6/14/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "NoteCustomCell.h"
#import "Colors.h"
#import "AlarmC+CoreDataClass.h"
#import "Date.h"

@interface NoteCustomCell ()
@property (weak, nonatomic) IBOutlet UILabel *lblNoteTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNoteDate;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlarm;
@property (weak, nonatomic) IBOutlet UIImageView *imgAttachmment;
@property (weak, nonatomic) IBOutlet UIView *vRed;
@property (weak, nonatomic) IBOutlet UIImageView *imgLoccation;

@property (weak, nonatomic) IBOutlet UIButton *btnChecked;
- (IBAction)btnCheckedAction:(id)sender;

@end




@implementation NoteCustomCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

 
}
-(NoteCustomCell *)loadCell:(NoteCustomCell *)cell
                       task:(TaskC *)task
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
    int locationCount = 0;
    
    NSArray *alarmsArray = [task.alarms allObjects];
    for (AlarmC *alarm in alarmsArray)
    {
        
        if (alarm.isSet == YES)
        {
            count ++;
        }
    }
    if (count > 0)
    {
        self.imgAlarm.hidden = NO;
    }
    else
    {
        self.imgAlarm.hidden = YES;
    }
    if ([task.attachments count] > 0)
    {
        self.imgAttachmment.hidden = NO;
    }
    else
    {
        self.imgAttachmment.hidden = YES;
    }
    NSArray *locationsArray = [task.locations allObjects];
    
    locationCount = (int)[locationsArray count];
    if (locationCount > 0)
    {
        self.imgLoccation.hidden = NO;
    }
    else
    {
        self.imgLoccation.hidden = YES;
    }

    NSDateFormatter *formatter = [Date getDateForrmater:@"allNotesCell"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    NSString *noteTitle = task.title;
    [self.lblNoteTitle setText:noteTitle];
    [self.lblNoteDate setText:stringFromDate];
    
    UIImage *btnImage = [[UIImage alloc] init];
    
    if (task.isDone == YES)
    {
        btnImage = [UIImage imageNamed:@"checkRedGreen.png"];
        [self.btnChecked setImage:btnImage forState:UIControlStateNormal];
    }
    else
    {
        btnImage = [UIImage imageNamed:@"circle.png"];
        [self.btnChecked setImage:btnImage forState:UIControlStateNormal];
    }

    
    return cell;
}

- (IBAction)btnCheckedAction:(id)sender
{
    if (self.actionNoteChecked)
    {
        self.actionNoteChecked();
      
    }
}
@end
