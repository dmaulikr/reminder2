//
//  AttachmentsC+CoreDataProperties.h
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "AttachmentsC+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AttachmentsC (CoreDataProperties)

+ (NSFetchRequest<AttachmentsC *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *attachmentID;
@property (nullable, nonatomic, copy) NSString *imgName;
@property (nullable, nonatomic, retain) TaskC *taskk;

@end

NS_ASSUME_NONNULL_END
