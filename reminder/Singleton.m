//
//  Singleton.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton


-(void)addNewTask:(Task *)task
{
    [self.tasksArray addObject:task];
}
-(NSMutableDictionary *)loadAll
{
    return self.tasksByDates;
}
-(NSMutableArray *)loadAllTasks
{
    return self.tasksArray;
    
}
-(void)deleteTask:(Task *)task
{
    for (Task *task2 in self.tasksArray) {
        if ([task2 isEqual:task]) {
            [self.tasksArray removeObject:task2];
            break;
        }
    }
    
}
+(id)sharedInstance{
    
    static Singleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tasksArray = [[NSMutableArray alloc] init];
        self.tasksByDates = [[NSMutableDictionary alloc] init];
        
        
        
        
        Task *task1 = [[Task alloc] init];
        task1.title = @"dfsfagsfas";
        task1.content = @"sdfgaaaaaaaasdf";
        task1.date = nil;
        task1.dateString = @"12-05-17";
        
        Task *task2 = [[Task alloc] init];
        task2.title = @"dfsffs";
        task2.content = @"sdfsgsfgdf";
        task2.date = nil;
        task2.dateString = @"12-05-17";
        
        Task *task3 = [[Task alloc] init];
        task3.title = @"asaddfsfs";
        task3.content = @"sdfasfsdf";
        task3.date = nil;
        task3.dateString = @"13-05-17";
        
        Task *task4 = [[Task alloc] init];
        task4.title = @"333dfsfs";
        task4.content = @"sfgddfsdf";
        task4.date = nil;
        task4.isDone = YES;
        task4.dateString = @"13-05-17";
        
        Task *task5 = [[Task alloc] init];
        task5.title = @"3113dfsfs";
        task5.content = @"s31dfsdf";
        task5.date = nil;
        task5.dateString = @"13-05-17";
        
        Task *task6 = [[Task alloc] init];
        task6.title = @"333s113dfsfs";
        task6.content = @"s31dfsdf";
        task6.date = nil;
        task6.dateString = @"13-05-17";
        
        Task *task7 = [[Task alloc] init];
        task7.title = @"333s113dfsfs";
        task7.content = @"s31dfsdf";
        task7.date = nil;
        task7.dateString = @"14-05-17";
        
        [self.tasksArray addObject:task1];
        [self.tasksArray addObject:task2];
        [self.tasksArray addObject:task3];
        [self.tasksArray addObject:task4];
        [self.tasksArray addObject:task5];
        [self.tasksArray addObject:task6];
        [self.tasksArray addObject:task7];
        
        
        for (Task *task in self.tasksArray)
        {
            NSString *dateStr = task.dateString;
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (Task *taskInner in self.tasksArray)
            {
                if ([dateStr isEqualToString:taskInner.dateString])
                {
                    [array addObject:task];
                    [self.tasksByDates setObject:array forKey:dateStr];
                }
            }
        }
        NSLog(@"objk %@", self.tasksByDates);
    }
    return self;
}
-(void)updateTask:(Task *)task index:(int)index
{
    [self.tasksArray replaceObjectAtIndex:index withObject:task];
}
-(void)setCompleted:(Task *)task index:(int )index
{
    
}
-(void)update:(Task *)task
{
    Task *updatedTask = task;
    
    for(int i = 0; i<[self.tasksArray count]; i++)
    {
        if ([task isEqual:[self.tasksArray objectAtIndex:i]])
        {
            [self.tasksArray replaceObjectAtIndex:i withObject:updatedTask];
        }
    }
}
@end
