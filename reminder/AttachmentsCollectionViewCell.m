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


@interface AttachmentsCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgVCollectionCell;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveCellImage;

@end

@implementation AttachmentsCollectionViewCell

-(void )loadCell:(TaskC *)task
                        indexPath:(NSIndexPath *)indexPath
                                    viewController:(PopTaskViewController *)viewCont;
{
    Singleton *instance = [Singleton sharedInstance];
    [instance.buttons addObject:self.btnRemoveCellImage];

    [self.btnRemoveImg addTarget:self
                       action:@selector(removeImage:)
       forControlEvents:UIControlEventTouchUpInside];
    UIImage *image = [[UIImage alloc] init];
    NSArray *array = [task.attachments allObjects];
    AttachmentsC *attachment = [array objectAtIndex:indexPath.row];
    NSString *imagePath = attachment.imgName;
    image = [UIImage imageWithContentsOfFile:imagePath];

//    if (task.attachmentsArray)
//    {
//        image = [task.attachmentsArray objectAtIndex:indexPath.row];
//        
//    }
    [self.imgVCollectionCell setImage:image];
    self.actionRemoveNoteImage = ^
    {
     
//        UIImage *imageToDelete = [task.attachmentsArray objectAtIndex:indexPath.row];
//        
//        for (UIImage *img in task.attachmentsArray)
//        {
//            if ([img isEqual:imageToDelete])
//            {
//                [task.attachmentsArray removeObject:img];
//                
//                break;
//            }
//        }
    };
    [instance.buttons addObject:self.btnRemoveCellImage];
}
-(IBAction)removeImage:(UIButton *)sender
{
    if (self.actionRemoveNoteImage)
    {
        self.actionRemoveNoteImage();
    }
    
    [self.delegate imgRemoved];
    
}
-(void)attachmentsBrnPressed
{
    Singleton *instence = [Singleton sharedInstance];
    for (UIButton *button in instence.buttons)
    {
        button.hidden = NO;
    }
}

@end
