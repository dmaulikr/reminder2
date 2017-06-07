//
//  AddViewController.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AddViewController.h"
#import "Singleton.h"

@interface AddViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *tNoteTItle;
@property (weak, nonatomic) IBOutlet UITextView *tNoteContent;

@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tNoteTItle.delegate = self;
    self.tNoteContent.delegate = self;
}


- (IBAction)backAdd:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnAddPressed:(id)sender
{
    
    Task *task = [[Task alloc] init];
    NSString *noteTitle = self.tNoteTItle.text;
    NSString *noteContent = self.tNoteContent.text;
    
    task.title = noteTitle;
    task.content = noteContent;
    
    Singleton *singleton = [Singleton sharedInstance];
    [singleton addNewTask:task];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.tNoteTItle)
    {
        if ([textView.text isEqualToString:@"Task title"])
        {
            self.tNoteTItle.text = @"";
        }else
        {
            return;
        }
    }
    else if (textView == self.tNoteContent)
    {
        if ([textView.text isEqualToString:@"Task content"])
        {
            self.tNoteContent.text = @"";
        }else
        {
            return;
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.tNoteTItle )
    {
        if ([textView.text isEqualToString:@""])
        {
            self.tNoteTItle.text = @"Task title";
        }else
        {
            return;
        }
    }
    else if (textView == self.tNoteContent)
    {
        if ([textView.text isEqualToString:@""])
        {
            self.tNoteContent.text = @"Task content";
        }else
        {
            return;
        }
    }
}
@end
