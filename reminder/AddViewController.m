//
//  AddViewController.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AddViewController.h"
#import "Singleton.h"
#import <CoreData/CoreData.h>

#import "TaskC+CoreDataClass.h"
#import "AttachmentsC+CoreDataClass.h"
#import "LocationC+CoreDataClass.h"
#import "AlarmC+CoreDataClass.h"

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

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    Task *task = [[Task alloc] init];
    NSString *noteTitle = self.tNoteTItle.text;
    NSString *noteContent = self.tNoteContent.text;
    NSDate *date = [NSDate date];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    NSDate *dateFromString = [formatter dateFromString:stringFromDate];
    
    
    task.title = noteTitle;
    task.content = noteContent;
    task.date = dateFromString;
    
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
        }
        else
        {
            return;
        }
    }
    else if (textView == self.tNoteContent)
    {
        if ([textView.text isEqualToString:@""])
        {
            self.tNoteContent.text = @"Task content";
        }
        else
        {
            return;
        }
    }
}
- (IBAction)addCoreData:(id)sender {
    
    
    Singleton *instance = [Singleton sharedInstance];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    
    NSString *dateString = [formatter stringFromDate:[NSDate new]];
    
    
    NSDate *date = [formatter dateFromString:dateString];

    
    
    NSManagedObjectContext *context = instance.coreData.managedObjectContext;
    NSManagedObject *entiry;
    
    entiry = [NSEntityDescription insertNewObjectForEntityForName:@"TaskC" inManagedObjectContext:context];
    [entiry setValue:self.tNoteTItle.text forKey:@"title"];
    [entiry setValue:self.tNoteContent.text forKey:@"content"];
    [entiry setValue:date forKey:@"date"];
    
    [entiry setValue:0 forKey:@"isLiked"];
    [entiry setValue:0 forKey:@"hasAlert"];
    [entiry setValue:0 forKey:@"isDone"];
    
    
    [instance.coreData saveContext];
    
    
}
- (IBAction)loadCoreData:(id)sender {
    
    Singleton *instance = [Singleton sharedInstance];
    
    NSManagedObjectContext *context = [instance.coreData managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"notes   --- > %@", objects);
    
    for (int i = 0; i<[objects count]; i++) {
        TaskC *task = (TaskC *)objects[i];
        
        NSLog(@"%@", task.title);
        NSLog(@"%@", task.content);
        NSLog(@"%@", task.date);
        
    }
    
    
}
- (IBAction)deleteAll:(id)sender {
    
    Singleton *instance = [Singleton sharedInstance];
    
    NSManagedObjectContext *context = [instance.coreData managedObjectContext];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"TaskC"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [context executeRequest:delete error:&deleteError];
    
    
}
@end
