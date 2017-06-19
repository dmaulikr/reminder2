//
//  AttachmentsCollectionViewCell.m
//  reminder
//
//  Created by Nikola on 6/8/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AttachmentsCollectionViewCell.h"
#import "PopTaskViewController.h"
#import "Singleton.h"
#import "TaskC+CoreDataClass.h"
#import "AttachmentsC+CoreDataClass.h"


@interface AttachmentsCollectionViewCell () <PopViewControllerDellegate>
{
    __weak TaskC *taskPop;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgVCollectionCell;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveCellImage;
@property (atomic, assign) BOOL hiddenBtn;



@end

@implementation AttachmentsCollectionViewCell

-(void )loadCell:(TaskC *)taskc
                        indexPath:(NSIndexPath *)indexPath
                                    viewController:(PopTaskViewController *)viewCont;
{
    Singleton *instance = [Singleton sharedInstance];
    [instance.buttons addObject:self.btnRemoveCellImage]; // mozda ovde pravi problem

    [self.btnRemoveImg addTarget:self
                       action:@selector(removeImage:)
       forControlEvents:UIControlEventTouchUpInside];
    
    viewCont.delegate = self;
    
    self.btnRemoveCellImage.hidden = YES;
    if (self.hidden == YES)
    {
        self.btnRemoveCellImage.hidden = NO;
    }
  
    NSArray *array = [taskc.attachments allObjects];
    AttachmentsC *attachment = [array objectAtIndex:indexPath.row];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        
        
        NSString *imagePath = attachment.imgName;
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
                                                           stringByAppendingPathComponent:imagePath]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.imgVCollectionCell setImage:image];
        });
    });
    
    self.actionRemoveNoteImage = ^
    {
        TaskC *task = [instance removeImage:attachment forTask:taskc];
        taskPop = task;
    };

}
-(IBAction)removeImage:(UIButton *)sender
{
    if (self.actionRemoveNoteImage)
    {
        self.actionRemoveNoteImage();
        [self.delegate imgRemovedForTask:taskPop];
    }
}
-(void)attachmentsBrnPressed
{
    Singleton *instence = [Singleton sharedInstance];
    for (UIButton *button in instence.buttons)
    {
        button.hidden = NO;
    }
}
-(void)showImageRemoveButtons:(int)hidden
{
    Singleton *instence = [Singleton sharedInstance];
    NSLog(@"showing btns ");
    for (UIButton *button in instence.buttons)
    {
        if (hidden == 1)
        {
            button.hidden = NO;
            self.hidden = NO;
        }
        else if (hidden == 0)
        {
            button.hidden = YES;
            self.hidden = YES;
        }
    }
}

@end
