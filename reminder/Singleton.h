//
//  Singleton.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Task.h"
#import "MainViewController.h"
#import "CoreData.h"
#import "TaskC+CoreDataClass.h"

@interface Singleton : NSObject 

@property (strong, nonatomic) NSMutableArray *tasksArray;
@property (strong, nonatomic) NSMutableDictionary *tasksByDates;
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (strong, nonatomic) MainViewController *mainVC;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) CoreData *coreData;


+(id)sharedInstance;





-(void)addNewTask:(Task *)task;
-(NSMutableArray *)loadAllTasks;
-(void)deleteTask:(Task *)task;
-(void)setCompleted:(Task *)task index:(int )index;
-(void)updateTask:(Task *)task index:(int )index;
-(void)update:(Task *)task;
-(NSMutableDictionary *)loadAll;

-(void)sort;
-(void)taskChecked:(TaskC *)task;
-(void)addNewImage:(UIImage *)image
           forTask:(TaskC *)task;
-(TaskC *)like:(TaskC *)task;
-(TaskC *)unlike:(TaskC *)task;
-(NSMutableArray *)getAllTasks;
-(NSMutableArray *)getAllFavoritedDate;
-(void)loadCoreData;
-(void)coreDataUpdated;
-(TaskC *)removeImage:(AttachmentsC *)attachment
           forTask:(TaskC *)task;


@end
