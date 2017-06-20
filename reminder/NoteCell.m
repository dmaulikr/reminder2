//
//  NoteCell.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "NoteCell.h"
#import "Constants.h"
#import "Colors.h"
#import "MainViewController.h"
#import "AlarmC+CoreDataClass.h"
#import "Date.h"

@interface NoteCell () <MainViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTaskName;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskDate;
@property (weak, nonatomic) IBOutlet UIButton *btnTaskChecked;
@property (weak, nonatomic) IBOutlet UIView *vRed;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlarm;
@property (weak, nonatomic) IBOutlet UIImageView *imgAttachment;
@property (weak, nonatomic) IBOutlet UILabel *imgLocation;

@end
@implementation NoteCell

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(NoteCell *)loadCell:(NoteCell *)cell task:(TaskC *)task
{
    if (task.isDone == YES)
    {
        self.lblTaskName.textColor = [Colors gray];
        self.lblTaskDate.textColor = [Colors gray];
        cell.backgroundColor = [Colors lightGray];
    }
    else
    {
        self.lblTaskName.textColor = [UIColor blackColor];
        self.lblTaskDate.textColor = [UIColor blackColor];
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
    NSArray *locationsArray = [task.locations allObjects];
    
    locationCount = (int)[locationsArray count];
    if (locationCount > 0)
    {
        self.imgLocation.hidden = NO;
    }
    else
    {
        self.imgLocation.hidden = YES;
    }
    if ([task.attachments count] > 0)
    {
        self.imgAttachment.hidden = NO;
    }
    else
    {
        self.imgAttachment.hidden = YES;
    }
    NSDateFormatter *formatter = [Date getDateForrmater:@"allNotesCell"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    NSString *noteTitle = task.title;
    [self.lblTaskName setText:noteTitle];
    [self.lblTaskDate setText:stringFromDate];
    
    self.btnTaskChecked =  (UIButton *)[cell viewWithTag:4];
    
    UIImage *btnImage = [[UIImage alloc] init];

        if (task.isDone == YES)
        {
            btnImage = [UIImage imageNamed:@"checkRedGreen.png"];
            [self.btnTaskChecked setImage:btnImage forState:UIControlStateNormal];
        }
        else
        {
            btnImage = [UIImage imageNamed:@"circle.png"];
            [self.btnTaskChecked setImage:btnImage forState:UIControlStateNormal];
        }
    return cell;
}

-(IBAction)checkBtnPresserd
{
    if (self.actionNoteChecked)
    {
        self.actionNoteChecked();
        
    }
}

-(void)taskChecked:(NSIndexPath *)indexPath
{
    
}

@end
