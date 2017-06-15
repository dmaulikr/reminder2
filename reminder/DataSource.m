//
//  DataSource.m
//  reminder
//
//  Created by Nikola on 6/15/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "DataSource.h"
#import "Singleton.h"

@implementation DataSource
+(NSMutableArray *)getDataSourceWithName:(NSString *)name
{
    
    Singleton *instance = [Singleton sharedInstance];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if (instance)
    {
        if ([name isEqualToString:@"allTasks"])
        {
            array = [instance getAllTasks];
        }
        else if ([name isEqualToString:@"favorites"])
        {
            array = [instance getAllFavoritedDate];
        }
        else
        {
            NSLog(@"Unable to get data source!");
        }
    }
    return array;
}
+(NSMutableDictionary *)getDataSourceByDates
{
    Singleton *instance = [Singleton sharedInstance];
    NSMutableDictionary *datesDictinary = [[NSMutableDictionary alloc] init];
    
    if (instance)
    {
        datesDictinary = [instance loadAll];
    }
    return datesDictinary;
}
+(void)updateDataSourceWithOperation:(NSString *)name
                                task:(TaskC *)task
                               alarm:(NSManagedObject *)alarm
                          attachment:(NSManagedObject *)attachment
                            location:(NSManagedObject *)location;
{
    Singleton *instance = [Singleton sharedInstance];
    
    if ([name isEqualToString:@"deleteTask"])
    {
        [instance.coreData deleteTask:task];
        [instance coreDataUpdated];
    }
    else if ([name isEqualToString:@"deleteAlarm"])
    {
        [instance.coreData deleteAlarm:alarm];
        [instance coreDataUpdated];
    }
    else if ([name isEqualToString:@"deleteAttachment"])
    {
        
    }
    else if ([name isEqualToString:@"taskDone"])
    {
        [instance taskChecked:task];
    }
    else if ([name isEqualToString:@"deleteAttachment"])
    {
        
    }
    

}
@end
