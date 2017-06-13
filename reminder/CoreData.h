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

@end
