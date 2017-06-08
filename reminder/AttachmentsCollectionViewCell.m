//
//  AttachmentsCollectionViewCell.m
//  reminder
//
//  Created by Nikola on 6/8/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AttachmentsCollectionViewCell.h"

@implementation AttachmentsCollectionViewCell

-(AttachmentsCollectionViewCell *)loadCell:(AttachmentsCollectionViewCell *)cell task:(Task *)task;
{
    self.btnAddImg = (UIButton *)[cell viewWithTag:11];
    self.btnAddImg.hidden = YES;
    
    self.btnRemoveImg = (UIButton *)[cell viewWithTag:14];
    self.btnRemoveImg.hidden = YES;
    
    self.img = (UIImageView *)[cell viewWithTag:15];

    [self.btnAddImg addTarget:self
                       action:@selector(removeImage:)
       forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)removeImage:(UIButton *)sender
{
    NSLog(@"btn pressed");
}
@end
