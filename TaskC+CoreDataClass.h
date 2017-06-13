//
//  TaskC+CoreDataClass.h
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlarmC, AttachmentsC, LocationC;

NS_ASSUME_NONNULL_BEGIN

@interface TaskC : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "TaskC+CoreDataProperties.h"
