//
//  AttachmentsCollectionViewCell.h
//  reminder
//
//  Created by Nikola on 6/8/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "PopTaskViewController.h"
#import "TaskC+CoreDataClass.h"


@protocol AttachmentsDelegate <NSObject>

-(void)imgRemoved;

@end

@interface AttachmentsCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIButton *btnRemoveImg;
@property (strong, nonatomic) UIButton *btnAddImg;
@property (strong, nonatomic) UIImageView *img;

-(void )loadCell:(TaskC *)task
       indexPath:(NSIndexPath *)indexPath
  viewController:(PopTaskViewController *)viewCont;


@property (nonatomic, copy) void(^actionRemoveNoteImage)(void);


@property (weak, nonatomic) id<AttachmentsDelegate> delegate;

@end
