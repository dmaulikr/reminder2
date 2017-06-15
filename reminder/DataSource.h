//
//  DataSource.h
//  reminder
//
//  Created by Nikola on 6/15/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskC+CoreDataClass.h"
#import "LocationC+CoreDataClass.h"
#import "AttachmentsC+CoreDataClass.h"

@interface DataSource : NSObject

+(NSMutableArray *)getDataSourceWithName: (NSString *)name;
+(NSMutableDictionary *)getDataSourceByDates;
+(void)updateDataSourceWithOperation:(NSString *)name
                                task:(TaskC *)task
                               alarm:(NSManagedObject *)alarm
                          attachment:(NSManagedObject *)attachment
                            location:(NSManagedObject *)location;

@end
