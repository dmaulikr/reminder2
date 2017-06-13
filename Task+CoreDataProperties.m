//
//  Task+CoreDataProperties.m
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Task"];
}

@dynamic taskID;
@dynamic title;
@dynamic content;
@dynamic date;
@dynamic dateString;
@dynamic imageString;
@dynamic attachmentsArray;
@dynamic alertDate;
@dynamic location;
@dynamic alarm;
@dynamic alarmsArray;
@dynamic isLiked;
@dynamic idDone;
@dynamic hasAlert;

@end
