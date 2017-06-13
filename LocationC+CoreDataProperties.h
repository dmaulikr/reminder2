//
//  LocationC+CoreDataProperties.h
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "LocationC+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface LocationC (CoreDataProperties)

+ (NSFetchRequest<LocationC *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longnitude;
@property (nullable, nonatomic, retain) TaskC *task;

@end

NS_ASSUME_NONNULL_END
