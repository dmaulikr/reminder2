//
//  AlarmC+CoreDataProperties.h
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AlarmC+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AlarmC (CoreDataProperties)

+ (NSFetchRequest<AlarmC *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *alarmTitle;
@property (nullable, nonatomic, copy) NSDate *alarmDate;
@property (nullable, nonatomic, copy) NSString *alarmID;
@property (nonatomic) BOOL isSet;
@property (nullable, nonatomic, retain) TaskC *relationship;

@end

NS_ASSUME_NONNULL_END
