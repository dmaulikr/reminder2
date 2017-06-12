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

@interface Singleton : NSObject 

@property (strong, nonatomic) NSMutableArray *tasksArray;
@property (strong, nonatomic) NSMutableDictionary *tasksByDates;
@property (strong, nonatomic) UIStoryboard *storyBoard;
@property (strong, nonatomic) MainViewController *mainVC;
@property (strong, nonatomic) NSMutableArray *buttons;


+(id)sharedInstance;
-(void)addNewTask:(Task *)task;
-(NSMutableArray *)loadAllTasks;
-(void)deleteTask:(Task *)task;
-(void)setCompleted:(Task *)task index:(int )index;
-(void)updateTask:(Task *)task index:(int )index;
-(void)update:(Task *)task;
-(NSMutableDictionary *)loadAll;
-(NSString*)timeSince:(NSDate*)date;
-(void)sort;
-(void)taskChecked:(Task *)task;

@end
