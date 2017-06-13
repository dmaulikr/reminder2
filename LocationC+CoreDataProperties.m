//
//  LocationC+CoreDataProperties.m
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "LocationC+CoreDataProperties.h"

@implementation LocationC (CoreDataProperties)

+ (NSFetchRequest<LocationC *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"LocationC"];
}

@dynamic latitude;
@dynamic longnitude;
@dynamic task;

@end
