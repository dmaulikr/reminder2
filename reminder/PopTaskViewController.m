//
//  PopTaskViewController.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "PopTaskViewController.h"
#import "AttachmentsCollectionViewCell.h"

@interface PopTaskViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textViewTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTaskDate;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;
@property (weak, nonatomic) IBOutlet UIButton *btnAlert;
- (IBAction)doneBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vContent;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIView *vCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnAttachmnent;
- (IBAction)showAttachments:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vAttachBtn;

//@property (strong, nonatomic) UIButton *btnRemoveImg;
//@property (strong, nonatomic) UIButton *btnAddImg;
//@property (strong, nonatomic) UIImageView *img;

@property(nonatomic, assign) int hidden;

@end

@implementation PopTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textViewContent.delegate = self;
    self.textViewTitle.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.textViewTitle setText:self.task.title];
    [self.textViewContent setText:self.task.content];
    self.hidden = 0;
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AttachmentsCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor greenColor];
    
    return cell;
}

- (IBAction)showAttachments:(id)sender
{
    if (self.hidden == 0)
    {
        self.hidden = 1;
//        self.btnRemoveImg.hidden = NO;
//        self.btnAddImg.hidden = NO;
        
    }
    else
    {
//        self.btnRemoveImg.hidden = YES;
//        self.btnAddImg.hidden = YES;
        self.hidden = 0;
    }
    
}

@end
