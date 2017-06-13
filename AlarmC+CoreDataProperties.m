//
//  AlarmC+CoreDataProperties.m
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AlarmC+CoreDataProperties.h"

@implementation AlarmC (CoreDataProperties)

+ (NSFetchRequest<AlarmC *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AlarmC"];
}

@dynamic alarmTitle;
@dynamic alarmDate;
@dynamic alarmID;
@dynamic isSet;
@dynamic relationship;

@end
