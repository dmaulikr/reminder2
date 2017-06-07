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

@implementation NoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}
+(NoteCell *)loadCell:(NoteCell *)cell task:(Task *)task
{
    
    
    UILabel *lblNoteTitle = (UILabel *)[cell viewWithTag:1];
    UILabel *lblNoteDate = (UILabel *)[cell viewWithTag:2];
//    UIView *vCheckMark = (UIView *)[cell viewWithTag:3];
    
    if (task.isDone == YES)
    {
        lblNoteTitle.textColor = [Colors gray];
        lblNoteDate.textColor = [Colors gray];
        cell.backgroundColor = [Colors lightGray];
    }else
    {
        lblNoteTitle.textColor = [UIColor blackColor];
        lblNoteDate.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    
    NSString *noteTitle = task.title;
    [lblNoteTitle setText:noteTitle];
    [lblNoteDate setText:stringFromDate];
    
    
    return cell;
}


-(void)checkBtnPresserd
{
    if (self.actionNoteChecked) {
        self.actionNoteChecked();
        
        self.actionNoteChecked = ^{
            
            
            
        };
    }
    
}



@end
