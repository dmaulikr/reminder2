//
//  Task+CoreDataProperties.h
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *taskID;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSString *dateString;
@property (nullable, nonatomic, copy) NSString *imageString;
@property (nullable, nonatomic, retain) NSObject *attachmentsArray;
@property (nullable, nonatomic, copy) NSDate *alertDate;
@property (nullable, nonatomic, retain) NSObject *location;
@property (nullable, nonatomic, retain) NSObject *alarm;
@property (nullable, nonatomic, retain) NSObject *alarmsArray;
@property (nonatomic) BOOL isLiked;
@property (nonatomic) BOOL idDone;
@property (nonatomic) BOOL hasAlert;

@end

NS_ASSUME_NONNULL_END
