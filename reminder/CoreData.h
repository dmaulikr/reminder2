//
//  CoreData.h
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "TaskC+CoreDataClass.h"

@interface CoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(id)sharedInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveNewImageWithPath:(NSString *)imagePath
                     forTask:(TaskC *)task;
- (void)taskChecked:(TaskC *)task;
- (void)taskUnchecked:(TaskC *)task;
- (TaskC *)like:(TaskC *)task;
- (TaskC *)unlike:(TaskC *)task;
- (void)addNewTaskWithTitle: (NSString *)title
                    content:(NSString *)content
                       date: (NSDate *)date
                    isLiked:(bool)liked
                     isDone: (bool)isDone
                     withID:(NSString *)generatedID;
- (void)updateTask:(TaskC *)task withTitle: (NSString *)title
                    content:(NSString *)content
                       date: (NSDate *)date
                    isLiked:(bool)liked
                     isDone: (bool)isDone
                     withID:(NSString *)generatedID;
- (void)deleteTask: (TaskC *)task;
- (void)addAlarmWithTitle: (NSString *)title
                     time:(NSDate *)time
                      set:(bool)set managedObject:(NSManagedObject *)object;
- (void)deleteAlarm:(NSManagedObject *)object;
- (TaskC *)deleteImage:(AttachmentsC *)object
            forTask:(TaskC *)task;
@end
