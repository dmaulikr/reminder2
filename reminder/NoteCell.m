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

@interface NoteCell () <MainViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTaskName;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskDate;

@property (weak, nonatomic) IBOutlet UIButton *btnTaskChecked;

@property (weak, nonatomic) IBOutlet UIView *vRed;


@end

@implementation NoteCell


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
-(NoteCell *)loadCell:(NoteCell *)cell task:(Task *)task
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    NSString *noteTitle = task.title;
    [self.lblTaskName setText:noteTitle];
    [self.lblTaskDate setText:stringFromDate];
    
    self.btnTaskChecked =  (UIButton *)[cell viewWithTag:4];
    
    UIImage *btnImage = [[UIImage alloc] init];

        if (task.isDone == YES)
        {
            btnImage = [UIImage imageNamed:@"checkRed.png"];
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
    if (self.actionNoteChecked) {
        self.actionNoteChecked();
        
    }
    
}

-(void)taskChecked:(NSIndexPath *)indexPath
{
    
}


@end
