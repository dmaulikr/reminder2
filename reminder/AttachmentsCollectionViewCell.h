//
//  AttachmentsCollectionViewCell.h
//  reminder
//
//  Created by Nikola on 6/8/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface AttachmentsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIButton *btnRemoveImg;
@property (strong, nonatomic) UIButton *btnAddImg;
@property (strong, nonatomic) UIImageView *img;

-(AttachmentsCollectionViewCell *)loadCell:(UITableViewCell *)cell task:(Task *)task;

@end
