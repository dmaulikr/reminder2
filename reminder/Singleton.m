//
//  Singleton.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Singleton.h"
#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "Alarm.h"
#import "Date.h"
#import "TaskC+CoreDataClass.h"
#import "AlarmC+CoreDataClass.h"
#import "AttachmentsC+CoreDataClass.h"
#import "LocationC+CoreDataClass.h"

@interface Singleton ()

@end

@implementation Singleton 



+(id)sharedInstance
{
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tasksArray = [[NSMutableArray alloc] init];
        self.tasksByDates = [[NSMutableDictionary alloc] init];
        self.buttons = [[NSMutableArray alloc] init];
        self.coreData = [CoreData sharedInstance];
        self.storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [self loadCoreData];
    }
    return self;
}
//-(void)addNewTask:(Task *)task
//{
//    [self.tasksArray addObject:task];
//    [self sort];
//}
-(NSMutableDictionary *)loadAll
{
    return self.tasksByDates;
}
-(NSMutableArray *)loadAllTasks
{
    return self.tasksArray;
}
//-(void)deleteTask:(Task *)task
//{
//    [self.tasksByDates removeAllObjects];
//    for (Task *task2 in self.tasksArray)
//    {
//        if ([task2 isEqual:task])
//        {
//            [self.tasksArray removeObject:task2];
//            break;
//        }
//    }
//}


//-(void)updateTask:(Task *)task index:(int)index
//{
//    [self.tasksArray replaceObjectAtIndex:index withObject:task];
//}
//-(void)setCompleted:(Task *)task index:(int )index
//{
//    
//}
//-(void)update:(Task *)task
//{
//    Task *updatedTask = task;
//    for(int i = 0; i<[self.tasksArray count]; i++)
//    {
//        if ([task isEqual:[self.tasksArray objectAtIndex:i]])
//        {
//            [self.tasksArray replaceObjectAtIndex:i withObject:updatedTask];
//        }
//    }
//}
#pragma coreData

-(void)sort
{
    NSDateFormatter *formatter = [Date getDateForrmater:@"sort"];

    for (TaskC *task in self.tasksArray)
    {
        NSString *dateString = [formatter stringFromDate:task.date];
        NSDate *date = [formatter dateFromString:dateString];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (TaskC *taskInner in self.tasksArray)
        {
            NSString *dateStringInner = [formatter stringFromDate:taskInner.date];
            NSDate *dateInner = [formatter dateFromString:dateStringInner];
            
            if ([date isEqualToDate:dateInner])
            {
                [array addObject:taskInner];
                [self.tasksByDates setObject:array forKey:date];
            }
        }
    }
}

-(void)taskChecked:(TaskC *)task
{
    for (TaskC *task2 in self.tasksArray)
    {
        if ([task.idTak isEqualToString:task2.idTak])
        {
            if (task2.isDone == YES)
            {
                [self.coreData taskUnchecked:task2];
                [self coreDataUpdated];
                break;
            }
            else
            {
                [self.coreData taskChecked:task2];
                [self coreDataUpdated];
                break;
            }
        }
    }
}
-(void)addNewImage:(UIImage *)image
           forTask:(TaskC *)task
{
    NSString *imagePath = [self generateImagePath:image];
    [self.coreData saveNewImageWithPath:imagePath forTask:task];
    
}
-(NSString *)generateImagePath:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *randomString = [[NSUUID UUID] UUIDString];
    NSString *path = [randomString substringToIndex:10];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",path]];

    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
    return path;
}
-(void)loadCoreData
{
    NSManagedObjectContext *context = [self.coreData managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];

    for (int i = 0; i<[objects count]; i++)
    {
        TaskC *task = (TaskC *)objects[i];
        [self.tasksArray addObject:task];
        NSLog(@"%@", task.date);
    }
    self.tasksArray = [self sortCoreDataByDate];
    [self sort];
}
-(void)coreDataUpdated
{
    [self.tasksArray removeAllObjects];
    NSManagedObjectContext *context = [self.coreData managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:fetchRequest error:&error];

    for (int i = 0; i<[objects count]; i++)
    {
        TaskC *task = (TaskC *)objects[i];
        [self.tasksArray addObject:task];
        NSLog(@"%@", task);
    }
    self.tasksArray = [self sortCoreDataByDate];
    [self sort];
}
-(NSMutableArray *)sortCoreDataByDate
{
    NSArray *sorted = [self.tasksArray sortedArrayUsingComparator:^(id obj1, id obj2)
                            {
                           TaskC *t1 = (TaskC *)obj1;
                           TaskC *t2 = (TaskC *)obj2;
                           
                           NSDate *d1 = t1.date;
                           NSDate *d2 = t2.date;
                           if (d1>d2)
                           {
                               return (NSComparisonResult)NSOrderedAscending;
                           }
                           else
                           {
                               return (NSComparisonResult)NSOrderedDescending;
                           }

                       }];
    NSMutableArray *sortedM = [sorted mutableCopy];
    
    for (int i = 0; i<[sortedM count]; i++)
    {
        TaskC *task = (TaskC *)sortedM[i];
        NSLog(@"%@", task.date);
    }
    return sortedM;
}
-(TaskC *)like:(TaskC *)task
{
    NSManagedObjectContext *context = [self.coreData managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    TaskC *taskUpdated = [self.coreData like:task];
    [self coreDataUpdated];
    return taskUpdated;
}
-(TaskC *)unlike:(TaskC *)task
{
    
    NSManagedObjectContext *context = [self.coreData managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    TaskC *taskUpdated = [self.coreData unlike:task];
    [self coreDataUpdated];
    return taskUpdated;
}
-(NSMutableArray *)getAllTasks
{
    return [self sortCoreDataByDate];
}
-(NSMutableArray *)getAllFavoritedDate
{
    NSMutableArray *array = [self sortCoreDataByDate];
    NSMutableArray *arrayFavorites = [[NSMutableArray alloc] init];
    
    for (TaskC *task in array)
    {
        if (task.isLiked == YES)
        {
            [arrayFavorites addObject:task];
        }
    }
    return arrayFavorites;
}
-(TaskC *)removeImage:(AttachmentsC *)attachment
           forTask:(TaskC *)task
{
    TaskC *taskUpdated = [self.coreData deleteImage:attachment forTask:task];
    [self coreDataUpdated];
    return taskUpdated;
}
@end
