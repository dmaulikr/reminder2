//
//  TaskC+CoreDataProperties.m
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "TaskC+CoreDataProperties.h"

@implementation TaskC (CoreDataProperties)

+ (NSFetchRequest<TaskC *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TaskC"];
}

@dynamic idTak;
@dynamic title;
@dynamic content;
@dynamic date;
@dynamic isLiked;
@dynamic isDone;
@dynamic hasAlert;
@dynamic alarms;
@dynamic locations;
@dynamic attachments;

@end
