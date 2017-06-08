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
    [self sort];
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
    [self.tasksByDates removeAllObjects];
    for (Task *task2 in self.tasksArray)
    {
        if ([task2 isEqual:task])
        {
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
    if (self)
    {
        self.tasksArray = [[NSMutableArray alloc] init];
        self.tasksByDates = [[NSMutableDictionary alloc] init];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        Task *task1 = [[Task alloc] init];
        task1.title = @"dfsfagsfas";
        task1.content = @"sdfgaaaaaaaasdf";
        task1.dateString = @"08/06/2017";
        task1.date = [formatter dateFromString:task1.dateString];
        task1.imageString = @"asdf.png";
        
        
        Task *task2 = [[Task alloc] init];
        task2.title = @"dfsffs";
        task2.content = @"sdfsgsfgdf";
        
        task2.dateString = @"08/06/2017";
        task2.date = [formatter dateFromString:task2.dateString];

        Task *task3 = [[Task alloc] init];
        task3.title = @"asaddfsfs";
        task3.content = @"sdfasfsdf";
        task3.dateString = @"07/06/2017";
        task3.date = [formatter dateFromString:task3.dateString];
        
        Task *task4 = [[Task alloc] init];
        task4.title = @"333dfsfs";
        task4.content = @"sfgddfsdf";
        task4.isDone = YES;
        task4.dateString = @"07/06/2017";
        task4.date = [formatter dateFromString:task4.dateString];
        task4.imageString = @"asdf.png";
        
        Task *task5 = [[Task alloc] init];
        task5.title = @"4331123113dfsfs";
        task5.content = @"s31dfsdf";
        task5.dateString = @"03/06/2017";
        task5.date = [formatter dateFromString:task5.dateString];

        Task *task6 = [[Task alloc] init];
        task6.title = @"88333s113dfsfs";
        task6.content = @"s31dfsdf";
        task6.dateString = @"03/06/2017";
        task6.date = [formatter dateFromString:task6.dateString];

        Task *task7 = [[Task alloc] init];
        task7.title = @"222333s113dfsfs";
        task7.content = @"s31dfsdf";
        task7.dateString = @"03/06/2017";
        task7.date = [formatter dateFromString:task7.dateString];

        [self.tasksArray addObject:task1];
        [self.tasksArray addObject:task2];
        [self.tasksArray addObject:task3];
        [self.tasksArray addObject:task4];
        [self.tasksArray addObject:task5];
        [self.tasksArray addObject:task6];
        [self.tasksArray addObject:task7];
        
        [self sort];
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
-(NSString*)timeSince:(NSDate*)date {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *newDate = date;
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSDate *currDate = [NSDate date];
    
    int dif = [currDate timeIntervalSinceReferenceDate] - [newDate timeIntervalSinceReferenceDate];
    NSString *timeSinceString = [[NSString alloc] init];
    
    if (dif<86400)
    {
            timeSinceString = [NSString stringWithFormat:@"Today"];
    }
    else
    {
        dif = (dif/86400);
        if (dif==1)
        {
            timeSinceString = @"Yesterday";
        }
        else{
            timeSinceString = [dateFormatter stringFromDate:newDate];
        }
    }
    return timeSinceString;
}
-(void)sort
{
    for (Task *task in self.tasksArray)
    {
        NSDate *date = task.date;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (Task *taskInner in self.tasksArray)
        {
            if ([date isEqualToDate:taskInner.date])
            {
                [array addObject:taskInner];
                [self.tasksByDates setObject:array forKey:date];
            }
        }
    }
    NSLog(@"sorted --- >%@", self.tasksByDates);
    NSLog(@"");
}

@end
