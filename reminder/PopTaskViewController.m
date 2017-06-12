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

@interface PopTaskViewController () <UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AttachmentsDelegate, LocationViewControllerDelegate, MKMapViewDelegate >

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

@property (strong, nonatomic) UIButton *btnRemoveImg;
@property (strong, nonatomic) UIButton *btnAddImg;
@property (strong, nonatomic) UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *vAddBtn;

@property (strong, nonatomic) UIImage *chosenImage;

@property (strong, nonatomic) NSMutableArray *imagesArray;

@property(nonatomic, assign) int hidden;
@property(nonatomic, assign) int hiddenMap;

@property(nonatomic, assign) float startX;
@property(nonatomic, assign) float startY;


@property (weak, nonatomic) IBOutlet UIView *vMapView;
- (IBAction)btnLocationAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vMainContent;
@property (weak, nonatomic) IBOutlet UIView *vBtn;
@property (weak, nonatomic) IBOutlet UIStackView *stackViewMainContent;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
- (IBAction)btnLikeAction:(id)sender;

@property (weak, nonatomic) IBOutlet MKMapView *mapV;




@property (strong, nonatomic) Singleton *instance;

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
    
    [self.mapV addGestureRecognizer:tap];
    self.mapV.userInteractionEnabled = YES;

    self.textViewContent.delegate = self;
    self.textViewTitle.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.textViewTitle setText:self.task.title];
    [self.textViewContent setText:self.task.content];
    
    self.hidden = 0;
    self.hiddenMap = 0;

    
    self.lblTaskDate.text = self.task.dateString;
    self.vMapView.hidden = YES;
    
    UIImage *btnImage;
    
    if (self.task.isLiked == YES)
    {
        btnImage = [UIImage imageNamed:@"heartRed.png"];
        [self.btnLike setImage:btnImage forState:UIControlStateNormal];
    }
    else
    {
        btnImage = [UIImage imageNamed:@"heartWhite.png"];
        [self.btnLike setImage:btnImage forState:UIControlStateNormal];
        
    }

    [self resizeTextView];
    [self showAttachments];
    
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
    if (self.task.attachmentsArray) {
        return [self.task.attachmentsArray count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AttachmentsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];

    cell.delegate = self;
    
    [cell loadCell:self.task indexPath:indexPath viewController:self];
    
    self.btnRemoveImg = (UIButton *)[cell viewWithTag:15];
    self.btnRemoveImg.hidden = YES;
    
    self.img = (UIImageView *)[cell viewWithTag:16];
    
    return cell;
}

- (IBAction)showAttachments:(id)sender
{
    
    [self.delegate attachmentsBrnPressed];
    
    [self showAttachments];
    
}
-(void)showAttachments
{
    if (self.hidden == 0)
    {
        self.hidden = 1;

        self.vCollection.backgroundColor = [Colors darkColor];
        self.collectionView.backgroundColor = [Colors darkColor];
        self.vAddBtn.backgroundColor = [Colors darkColor];
        self.vAddBtn.hidden = NO;
        self.vCollection.hidden = NO;
        
        
        [self resizeTextView];
        return;
    }
    else
    {

        self.hidden = 0;
        self.vCollection.backgroundColor = [Colors yellowTask];
        self.collectionView.backgroundColor = [Colors yellowTask];
        self.vAddBtn.backgroundColor = [Colors yellowTask];
        self.vAddBtn.hidden = YES;
        self.vCollection.hidden = YES;
        
        [self resizeTextView];
        return;
    }
    //    [self.collectionView reloadData];

}
-(void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)removeImage:(UIButton *)sender
{
    NSLog(@"remove");
    
    [self.task.attachmentsArray removeObjectAtIndex:1];
    [self.collectionView reloadData];

}
-(IBAction)addImage:(UIButton *)sender
{
    
    NSLog(@"adding img");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Attach image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* pickFromGallery =
    [UIAlertAction actionWithTitle:@"Take a photo"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action)
     {
                               if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
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
    [self.task.attachmentsArray addObject:image];
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
        self.btnRemoveImg.hidden = NO;
        self.vCollection.backgroundColor = [Colors darkColor];
        self.collectionView.backgroundColor = [Colors darkColor];
        self.vAddBtn.backgroundColor = [Colors darkColor];
        
        
        [self resizeTextView];
    }
    else
    {
        self.stackViewMainContent.hidden = NO;
        self.vAddBtn.hidden = YES;
        self.btnRemoveImg.hidden = YES;
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
    
    if (self.task.isLiked == YES)
    {
        btnImage = [UIImage imageNamed:@"heartWhite.png"];
        [self.btnLike setImage:btnImage forState:UIControlStateNormal];
        self.task.isLiked = NO;
    }
    else
    {
        btnImage = [UIImage imageNamed:@"heartRed.png"];
        [self.btnLike setImage:btnImage forState:UIControlStateNormal];
        self.task.isLiked = YES;
    }

}
-(void)imgRemoved
{
    [self.collectionView reloadData];
}
-(IBAction)showLocation:(id)sender
{
    [self openLocation];
}
-(void)locationUpdated:(Location *)location imageDraw:(UIImage *)image
{

    self.task.locationAttachment = location;

    NSLog(@"lokcation --- > %@", location.latitude);
//    [self.imgViewMap setImage:image];
//    self.imgViewMap.hidden = NO;
//    
//    CLLocationCoordinate2D coord = {latitude: 37.423617, longitude: -122.220154};
//    MKCoordinateSpan span = {latitudeDelta: 1, longitudeDelta: 1};
//    MKCoordinateRegion region = {coord, span};
//    [mapView setRegion:region];
    
    [self loadLocation];
}
-(void)openLocation
{
    LocationViewController *vc = [self.instance.storyBoard instantiateViewControllerWithIdentifier:@"location"];
    vc.delegate = self;
    
    if (self.task.locationAttachment) {
        vc.location = self.task.locationAttachment;
    }
    
    
    [self presentViewController:vc animated:YES completion:nil];
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
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
