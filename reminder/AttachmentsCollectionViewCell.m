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



@interface AttachmentsCollectionViewCell () <PopViewControllerDellegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgVCollectionCell;
@property (weak, nonatomic) IBOutlet UIButton *btnRemoveCellImage;

@end

@implementation AttachmentsCollectionViewCell

-(void )loadCell:(Task *)task
                        indexPath:(NSIndexPath *)indexPath
                                    viewController:(PopTaskViewController *)viewCont;
{
    
    Singleton *instance = [Singleton sharedInstance];
    [instance.buttons addObject:self.btnRemoveCellImage];

    [self.btnRemoveImg addTarget:self
                       action:@selector(removeImage:)
       forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *image;
    
    if (task.attachmentsArray)
    {
        image = [task.attachmentsArray objectAtIndex:indexPath.row];
        
    }
    [self.imgVCollectionCell setImage:image];
    
    viewCont.delegate = self;
    
    self.actionRemoveNoteImage = ^
    {
     
        UIImage *imageToDelete = [task.attachmentsArray objectAtIndex:indexPath.row];
        
        for (UIImage *img in task.attachmentsArray)
        {
            if ([img isEqual:imageToDelete])
            {
                [task.attachmentsArray removeObject:img];
                
                break;
            }
        }
        
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

    for (UIButton *button in instence.buttons) {
        button.hidden = NO;
    }
}

@end
