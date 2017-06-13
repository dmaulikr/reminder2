//
//  TaskC+CoreDataProperties.h
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "TaskC+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TaskC (CoreDataProperties)

+ (NSFetchRequest<TaskC *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *idTak;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL isDone;
@property (nonatomic) BOOL hasAlert;
@property (nullable, nonatomic, retain) NSSet<AlarmC *> *alarms;
@property (nullable, nonatomic, retain) NSSet<LocationC *> *locations;
@property (nullable, nonatomic, retain) NSSet<AttachmentsC *> *attachments;

@end

@interface TaskC (CoreDataGeneratedAccessors)

- (void)addAlarmsObject:(AlarmC *)value;
- (void)removeAlarmsObject:(AlarmC *)value;
- (void)addAlarms:(NSSet<AlarmC *> *)values;
- (void)removeAlarms:(NSSet<AlarmC *> *)values;

- (void)addLocationsObject:(LocationC *)value;
- (void)removeLocationsObject:(LocationC *)value;
- (void)addLocations:(NSSet<LocationC *> *)values;
- (void)removeLocations:(NSSet<LocationC *> *)values;

- (void)addAttachmentsObject:(AttachmentsC *)value;
- (void)removeAttachmentsObject:(AttachmentsC *)value;
- (void)addAttachments:(NSSet<AttachmentsC *> *)values;
- (void)removeAttachments:(NSSet<AttachmentsC *> *)values;

@end

NS_ASSUME_NONNULL_END
