//
//  AttachmentsC+CoreDataProperties.m
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AttachmentsC+CoreDataProperties.h"

@implementation AttachmentsC (CoreDataProperties)

+ (NSFetchRequest<AttachmentsC *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"AttachmentsC"];
}

@dynamic attachmentID;
@dynamic imgName;
@dynamic taskk;

@end
