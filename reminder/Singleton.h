//
//  Singleton.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Task.h"

@interface Singleton : NSObject

@property (strong, nonatomic) NSMutableArray *tasksArray;
@property (strong, nonatomic) NSMutableDictionary *tasksByDates;


+(id)sharedInstance;
-(void)addNewTask:(Task *)task;
-(NSMutableArray *)loadAllTasks;
-(void)deleteTask:(Task *)task;
-(void)setCompleted:(Task *)task index:(int )index;
-(void)updateTask:(Task *)task index:(int )index;
-(void)update:(Task *)task;
-(NSMutableDictionary *)loadAll;


@end
