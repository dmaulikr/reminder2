        //
//  PopTaskViewController.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "PopTaskViewController.h"
#import "AttachmentsCollectionViewCell.h"
#import "Colors.h"
#import "LocationViewController.h"
#import "Singleton.h"
#import "LocationViewController.h"
#import "AlarmViewController.h"
#import <MapKit/MapKit.h>
#import "Date.h"

@interface PopTaskViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AttachmentsDelegate, LocationViewControllerDelegate, MKMapViewDelegate>
{
    NSString *operation;
    NSString *generatedIDforNewTask;
}

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


@property (strong, nonatomic) UIButton *btnAddImg;
@property (strong, nonatomic) UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *vAddBtn;
@property (strong, nonatomic) UIImage *chosenImage;
@property (strong, nonatomic) NSMutableArray *imagesArray;

@property(nonatomic, assign) int hidden;
@property(nonatomic, assign) int hiddenMap;
@property(nonatomic, assign) int number;
@property(nonatomic, assign) float startX;
@property(nonatomic, assign) float startY;
@property (assign, atomic) BOOL liked;

@property (weak, nonatomic) IBOutlet UIView *vMapView;
- (IBAction)btnLocationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vMainContent;
@property (weak, nonatomic) IBOutlet UIView *vBtn;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewMainContent;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
- (IBAction)btnLikeAction:(id)sender;

@property (weak, nonatomic) IBOutlet MKMapView *mapV;
@property (strong, nonatomic) Singleton *instance;
@property (strong, nonatomic) NSMutableArray<Location *> *arrayLocations;

@end

@implementation PopTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.instance = [Singleton sharedInstance];
    self.startX = 0;
    self.startY = 0;
    self.mapV.delegate = self;
    self.mapV.showsUserLocation = YES;
    self.mapV.scrollEnabled = NO;
    [self loadLocation];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLocation)];
    tap.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tapDismissKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewShouldEndEditing:)];
    tap.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:tapDismissKeyboard];
    [self.mapV addGestureRecognizer:tap];
    self.mapV.userInteractionEnabled = YES;
    self.textViewContent.delegate = self;
    self.textViewTitle.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.arrayLocations = [[NSMutableArray alloc] init];
    
    UIImage *btnImage;
    if (self.taskC)
    {
        [self.textViewTitle setText:self.taskC.title];
        [self.textViewContent setText:self.taskC.content];
        
        self.hidden = 0;
        self.hiddenMap = 0;
        self.lblTaskDate.text = self.task.dateString;
        self.vMapView.hidden = YES;
        
        if (self.taskC.isLiked == YES)
        {
            btnImage = [UIImage imageNamed:@"important.png"];
            [self.btnLike setImage:btnImage forState:UIControlStateNormal];
        }
        else
        {
            btnImage = [UIImage imageNamed:@"importantUnchecked.png"];
            [self.btnLike setImage:btnImage forState:UIControlStateNormal];
        }
        [self resizeTextView];
        NSString *dateString = [Date timeSince:self.taskC.date];
        self.lblTaskDate.text = dateString;

    }
    else
    {
        self.textViewTitle.text = @"Enter task title";
        [self.textViewContent setText:@""];
        self.hidden = 0;
        self.hiddenMap = 0;
        self.lblTaskDate.text = @"";
        self.vMapView.hidden = YES;
        self.liked = NO;
        
        btnImage = [UIImage imageNamed:@"importantUnchecked.png"];
        [self.btnLike setImage:btnImage forState:UIControlStateNormal];

    }
    
    if (!self.taskC)
    {
        operation = @"newTask";
        NSDateFormatter *formatter = [Date getDateForrmater:@"addToCoreData"];
        NSString *noteTitle = self.textViewTitle.text;
        NSString *noteContent = self.textViewContent.text;
        NSDate *date = [NSDate date];
        
        NSString *stringFromDate = [formatter stringFromDate:date];
        NSDate *dateFromString = [formatter dateFromString:stringFromDate];
        
        NSString *generatedRandomID = [[NSUUID UUID] UUIDString];
        
        Singleton *instance = [Singleton sharedInstance];
        [instance.coreData addNewTaskWithTitle:noteTitle
                                       content:noteContent
                                          date:dateFromString isLiked:self.liked
                                        isDone:NO
                                        withID:generatedRandomID];
        generatedIDforNewTask = generatedRandomID;
    }
    else
    {
        operation = @"editTask";
        generatedIDforNewTask = self.taskC.idTak;
    }
    
}
- (IBAction)doneBtn:(id)sender
{
    if ([self.textViewTitle.text isEqualToString:@""])
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter task title" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:^{
            }];
        });

        return;
    }
    if ([operation isEqualToString:@"editTask"])
    {
        [self editTask:self.taskC];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
//        NSDateFormatter *formatter = [Date getDateForrmater:@"addToCoreData"];
//        NSString *noteTitle = self.textViewTitle.text;
//        NSString *noteContent = self.textViewContent.text;
//        NSDate *date = [NSDate date];
//        
//        NSString *stringFromDate = [formatter stringFromDate:date];
//        NSDate *dateFromString = [formatter dateFromString:stringFromDate];
//        
//        NSString *generatedRandomID = [[NSUUID UUID] UUIDString];
//        
//        Singleton *instance = [Singleton sharedInstance];
//        [instance.coreData addNewTaskWithTitle:noteTitle
//                                       content:noteContent
//                                          date:dateFromString isLiked:self.liked
//                                        isDone:NO
//                                        withID:generatedRandomID];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTable" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataSourceUpdated" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"pravi se nova");
    }
}
-(void)editTask:(TaskC *)task
{
    NSString *taskTitle = self.textViewTitle.text;
    NSString *taskContnent = self.textViewContent.text;
    task.title = taskTitle;
    task.content = taskContnent;
    task.date = task.date;
    
    Singleton *instance = [Singleton sharedInstance];
    [instance.coreData updateTask:task
                        withTitle:taskTitle
                          content:taskContnent
                             date:task.date
                          isLiked:task.isLiked
                           isDone:task.isDone
                           withID:task.idTak];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = [self.taskC.attachments allObjects];
    NSLog(@"number of images --> %lu",(unsigned long)[array count]);
    return [array count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AttachmentsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell loadCell:self.taskC indexPath:indexPath viewController:self];
    self.img = (UIImageView *)[cell viewWithTag:16];
    return cell;
}

- (IBAction)showAttachments:(id)sender
{
    [self showAttachments];
}
-(void)showAttachments
{
    if (self.hidden == 0)
    {
        self.hidden = 1;
        [self.delegate showImageRemoveButtons:self.hidden];
        return;
    }
    else
    {
        self.hidden = 0;
        [self.delegate showImageRemoveButtons:self.hidden];
        return;
    }
}
-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)removeImage:(UIButton *)sender
{
    NSLog(@"remove");
    
    [self.task.attachmentsArray removeObjectAtIndex:1];
    self.number = (int)[self.taskC.attachments count];
    [self.collectionView reloadData];

}
-(IBAction)addImage:(UIButton *)sender
{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attach image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* pickFromGallery =
    [UIAlertAction actionWithTitle:@"Take a photo"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
                               if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                               {
                                   UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                   picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                   picker.delegate = self;
                                   [self presentViewController:picker animated:YES completion:NULL];
                               }
                           }];
    UIAlertAction* takeAPicture =
    [UIAlertAction actionWithTitle:@"Choose from gallery"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                               picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                               picker.delegate = self;
                               [self presentViewController:picker animated:YES completion:NULL];
                           }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * action)
    {
                                                   }];
    [alertController addAction:pickFromGallery];
    [alertController addAction:takeAPicture];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.chosenImage = chosenImage;
    if (self.chosenImage) {
        [self addNewImageAction:self.chosenImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
-(void)addNewImageAction:(UIImage *)image
{
    [self.instance addNewImage:image forTask:self.taskC];
    [self.collectionView reloadData];
}
- (IBAction)btnLocationAction:(id)sender
{
    self.vMapView.hidden = NO;
    if (self.hiddenMap == 0)
    {
        self.hiddenMap = 1;
        self.stackViewMainContent.hidden = NO;
        self.vMapView.hidden = NO;
        self.vAddBtn.hidden = NO;
        self.vCollection.backgroundColor = [Colors darkColor];
        self.collectionView.backgroundColor = [Colors darkColor];
        self.vAddBtn.backgroundColor = [Colors darkColor];
        [self resizeTextView];
    }
    else
    {
        self.stackViewMainContent.hidden = NO;
        self.vAddBtn.hidden = YES;
        self.hiddenMap = 0;
        self.vCollection.backgroundColor = [Colors yellowTask];
        self.collectionView.backgroundColor = [Colors yellowTask];
        self.vAddBtn.backgroundColor = [Colors yellowTask];
        self.vMapView.hidden = YES;
        [self resizeTextView];
    }
    [self resizeTextView];
}
-(void)resizeTextView
{
    ;
    CGFloat width = CGRectGetWidth(self.textViewContent.frame);
    if (self.stackViewMainContent.hidden)
    {
        CGFloat vMainContentHaight = CGRectGetHeight(self.vMainContent.frame) - CGRectGetHeight(self.vBtn.frame) - 20;
        CGRect frame = CGRectMake(8.0f, 43.0f, width, vMainContentHaight);
        self.textViewContent.frame = frame;
    }
    else if (self.vCollection.hidden & !self.vMapView.hidden)
    {
        CGFloat vMainContentHaight = CGRectGetHeight(self.vMainContent.frame) - CGRectGetHeight(self.vBtn.frame) - CGRectGetHeight(self.vCollection.frame)  - 20;
        CGRect fixedFrame = CGRectMake(8.0f, 43.0f, width, vMainContentHaight);
        self.textViewContent.frame = fixedFrame;
    }
    else if (!self.vCollection.hidden & self.vMapView.hidden)
    {
        CGFloat vMainContentHaight = CGRectGetHeight(self.vMainContent.frame) - CGRectGetHeight(self.vBtn.frame) - CGRectGetHeight(self.vMapView.frame)  - 20;
        CGRect fixedFrame = CGRectMake(8.0f, 43.0f, width, vMainContentHaight);
        self.textViewContent.frame = fixedFrame;
    }
    else if (self.vCollection.hidden & self.vMapView.hidden)
    {
        CGFloat width = CGRectGetWidth(self.textViewContent.frame);
        CGFloat vMainContentHaight = CGRectGetHeight(self.vMainContent.frame) - CGRectGetHeight(self.vBtn.frame) - CGRectGetHeight(self.vMapView.frame) - 20;
        CGRect frame = CGRectMake(8.0f, 43.0f, width, vMainContentHaight);
        self.textViewContent.frame = frame;
    }
    else if (!self.vCollection.hidden & !self.vMapView.hidden)
    {
        CGFloat vMainContentHaight = CGRectGetHeight(self.vMainContent.frame) - CGRectGetHeight(self.vBtn.frame)/2 - CGRectGetHeight(self.vMapView.frame) * 2;
        CGRect frame = CGRectMake(8.0f, 43.0f, width, vMainContentHaight);
        self.textViewContent.frame = frame;
    }
    else
    {
        CGFloat fixedHeight = 80.0f;;
        CGRect fixedFrame = CGRectMake(8.0f, 43.0f, width, fixedHeight);
        self.textViewContent.frame = fixedFrame;
    }
}
- (IBAction)btnLikeAction:(id)sender
{
    UIImage *btnImage;
    if ([operation isEqualToString:@"editTask"])
    {
        if (self.taskC.isLiked == YES)
        {
            self.taskC = [self.instance unlike:self.taskC];
            btnImage = [UIImage imageNamed:@"importantUnchecked.png"];
            [self.btnLike setImage:btnImage forState:UIControlStateNormal];
            [self updateCurrentTask];
        }
        else
        {
            
            self.taskC = [self.instance like:self.taskC];
            btnImage = [UIImage imageNamed:@"important.png"];
            [self.btnLike setImage:btnImage forState:UIControlStateNormal];
            [self updateCurrentTask];
        }
    }
    else
    {
        if (self.liked == NO)
        {
            self.taskC = [self.instance like:self.taskC];
            btnImage = [UIImage imageNamed:@"important.png"];
             [self.btnLike setImage:btnImage forState:UIControlStateNormal];
            self.liked = YES;
        }
        else
        {
            self.taskC = [self.instance unlike:self.taskC];
            btnImage = [UIImage imageNamed:@"importantUnchecked.png"];
            [self.btnLike setImage:btnImage forState:UIControlStateNormal];

            self.liked = NO;
        }
    }
}
-(IBAction)showLocation:(id)sender
{
    [self openLocation];
}
-(void)locationUpdated:(Location *)location imageDraw:(UIImage *)image
{
    self.task.locationAttachment = location;
    NSLog(@"lokcation --- > %@", location.latitude);
    [self loadLocation];
}
-(void)openLocation
{
    LocationViewController *vc = [self.instance.storyBoard instantiateViewControllerWithIdentifier:@"location"];
    vc.delegate = self;
    NSManagedObjectContext *context = [self.instance.coreData managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"idTak == %@", generatedIDforNewTask];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedTasks = [context executeFetchRequest:fetch error:&fetchError];
    TaskC *task = [fetchedTasks firstObject];
    
    vc.taskForLocation = task;
    [self presentViewController:vc animated:YES completion:nil];
    if (self.task.locationAttachment)
    {
        vc.location = self.task.locationAttachment;
    }
}
-(void)loadLocation
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        double latitude = [self.task.locationAttachment.latitude doubleValue];
        double lognitude = [self.task.locationAttachment.longnitude doubleValue];
        
        CLLocationCoordinate2D coord = {.latitude =  latitude, .longitude =  lognitude};
        MKCoordinateSpan span = {.latitudeDelta =  1, .longitudeDelta =  1};
        MKCoordinateRegion region = {coord, span};
        
        dispatch_async(dispatch_get_main_queue(), ^{

             [self.mapV setRegion:region];
        });
    });
}
- (IBAction)alarm:(id)sender
{
    AlarmViewController *vc = [self.instance.storyBoard instantiateViewControllerWithIdentifier:@"alarm"];
    vc.taskOpened = self.task;
    vc.taskCOpened = self.taskC;
    [self presentViewController:vc animated:YES completion:nil];
}
-(void)updateCurrentTask
{
    
}
-(void)imgRemovedForTask:(TaskC *)task
{
    self.taskC = task;
    [self.collectionView reloadData];
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.textViewTitle resignFirstResponder];
    [self.textViewContent resignFirstResponder];
    [self resignFirstResponder];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
        if ([textView.text isEqualToString:@"Enter task title"])
        {
            self.textViewTitle.text = @"";
        }else
        {
            return;
        }
    
    if (textView == self.textViewContent)
    {
    
        if ([textView.text isEqualToString:@"Enter task content"])
        {
            self.textViewContent.text = @"";
        }else
        {
            return;
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.textViewTitle )
    {
        if ([textView.text isEqualToString:@""])
        {
            self.textViewTitle.text = @"Task title";
        }
        else
        {
            return;
        }
    }
    else if (textView == self.textViewContent)
    {
        if ([textView.text isEqualToString:@""])
        {
            self.textViewContent.text = @"Task content";
        }
        else
        {
            return;
        }
    }
}

@end
