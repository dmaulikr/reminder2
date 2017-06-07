//
//  PopTaskViewController.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "PopTaskViewController.h"

@interface PopTaskViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskDate;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAlert;
- (IBAction)doneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vContent;

@end

@implementation PopTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textViewContent.delegate = self;
    self.textViewTitle.delegate = self;
    
    [self.textViewTitle setText:self.task.title];
    [self.textViewContent setText:self.task.content];
    

}


- (IBAction)doneBtn:(id)sender
{
    
    [self editTask:self.task];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)editTask:(Task *)task
{
    
    NSString *taskTitle = self.textViewTitle.text;
    NSString *taskContnent = self.textViewContent.text;
    
    task.title = taskTitle;
    task.content = taskContnent;
    task.date = [self getDate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
    
}
-(NSDate *)getDate
{
    NSDate *now = [[NSDate alloc] init];
    return now;
}


@end
