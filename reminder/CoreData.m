//
//  CoreData.m
//  reminder
//
//  Created by Nikola on 6/13/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData : NSObject

@synthesize managedObjectContext = managedObjectContext;
@synthesize managedObjectModel = managedObjectModel;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator;


+(id)sharedInstance{
    
    static CoreData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}
- (instancetype)init
{
    self = [super init];
    if (self)
    {

    }
    return self;
}

#pragma coreData delegate methods

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Data.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AppModel" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContextLcl = self.managedObjectContext;
    
    if (managedObjectContextLcl != nil) {
        if ([managedObjectContextLcl hasChanges] && ![managedObjectContextLcl save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
-(void)saveNewImageWithPath:(NSString *)imagePath
                    forTask:(TaskC *)task
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *taskObject = task;
    NSEntityDescription *entityAttachment = [NSEntityDescription entityForName:@"AttachmentsC" inManagedObjectContext:context];
    NSManagedObject *newImage = [[NSManagedObject alloc] initWithEntity:entityAttachment insertIntoManagedObjectContext:context];
    [newImage setValue:imagePath forKey:@"imgName"];
    NSMutableSet *attachments = [taskObject mutableSetValueForKey:@"attachments"];
    [attachments addObject:newImage];
    [self saveContext];

}
-(void)taskChecked:(TaskC *)task
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *taskObject = task;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    
    NSMutableSet *attachments = [task mutableSetValueForKey:@"attachments"];
    NSMutableSet *locations = [task mutableSetValueForKey:@"locations"];
    NSMutableSet *alarms = [task mutableSetValueForKey:@"alarms"];
// deleting
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts = [context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *task in fetchedProducts)
    {
        [context deleteObject:task];
    }
// puttin' back
    
    NSNumber *isDone = [[NSNumber alloc] initWithBool:YES];
    NSNumber *isLiked = [[NSNumber alloc] initWithBool:task.isLiked];
    
    taskObject = [NSEntityDescription insertNewObjectForEntityForName:@"TaskC" inManagedObjectContext:context];
    [taskObject setValue:task.title forKey:@"title"];
    [taskObject setValue:task.content forKey:@"content"];
    [taskObject setValue:task.date forKey:@"date"];
    [taskObject setValue:isLiked forKey:@"isLiked"];
    [taskObject setValue:0 forKey:@"hasAlert"];
    [taskObject setValue:isDone forKey:@"isDone"]; // YES
    [taskObject setValue:task.idTak forKey:@"idTak"];
    
    [taskObject setValue:alarms forKey:@"alarms"];
    [taskObject setValue:locations forKey:@"locations"];
    [taskObject setValue:attachments forKey:@"attachments"];
    [self saveContext];

}
-(void)taskUnchecked:(TaskC *)task
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *taskObject = task;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    
    NSMutableSet *attachments = [task mutableSetValueForKey:@"attachments"];
    NSMutableSet *locations = [task mutableSetValueForKey:@"locations"];
    NSMutableSet *alarms = [task mutableSetValueForKey:@"alarms"];
    // deleting
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts = [context executeFetchRequest:fetch error:&fetchError];
    
    for (NSManagedObject *task in fetchedProducts)
    {
        [context deleteObject:task];
    }
    // puttin' back
    
    NSNumber *isDone = [[NSNumber alloc] initWithBool:NO];
    NSNumber *isLiked = [[NSNumber alloc] initWithBool:task.isLiked];
    
    
    taskObject = [NSEntityDescription insertNewObjectForEntityForName:@"TaskC" inManagedObjectContext:context];
    [taskObject setValue:task.title forKey:@"title"];
    [taskObject setValue:task.content forKey:@"content"];
    [taskObject setValue:task.date forKey:@"date"];
    [taskObject setValue:isLiked forKey:@"isLiked"];
    [taskObject setValue:0 forKey:@"hasAlert"];
    [taskObject setValue:isDone forKey:@"isDone"]; // NO
    [taskObject setValue:task.idTak forKey:@"idTak"];
    [taskObject setValue:alarms forKey:@"alarms"];
    [taskObject setValue:locations forKey:@"locations"];
    [taskObject setValue:attachments forKey:@"attachments"];
    
    // saving
    [self saveContext];
}
-(TaskC *)like:(TaskC *)task
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *taskObject = task;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    NSMutableSet *attachments = [task mutableSetValueForKey:@"attachments"];
    NSMutableSet *locations = [task mutableSetValueForKey:@"locations"];
    NSMutableSet *alarms = [task mutableSetValueForKey:@"alarms"];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts = [context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *task in fetchedProducts)
    {
        [context deleteObject:task];
    }
    NSNumber *isDone = [[NSNumber alloc] initWithBool:task.isDone];
    NSNumber *isLiked = [[NSNumber alloc] initWithBool:YES];
    
    taskObject = [NSEntityDescription insertNewObjectForEntityForName:@"TaskC" inManagedObjectContext:context];
    [taskObject setValue:task.title forKey:@"title"];
    [taskObject setValue:task.content forKey:@"content"];
    [taskObject setValue:task.date forKey:@"date"];
    [taskObject setValue:isLiked forKey:@"isLiked"];
    [taskObject setValue:0 forKey:@"hasAlert"];
    [taskObject setValue:isDone forKey:@"isDone"];
    [taskObject setValue:task.idTak forKey:@"idTak"];
    
    [taskObject setValue:alarms forKey:@"alarms"];
    [taskObject setValue:locations forKey:@"locations"];
    [taskObject setValue:attachments forKey:@"attachments"];
    
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p2];
    NSArray *updatedTaskArray = [context executeFetchRequest:fetch error:&fetchError];
    TaskC *updatedTask = (TaskC *)[updatedTaskArray firstObject];
    
    
    [self saveContext];
    return updatedTask;
}
-(TaskC *)unlike:(TaskC *)task
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *taskObject = task;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    NSMutableSet *attachments = [task mutableSetValueForKey:@"attachments"];
    NSMutableSet *locations = [task mutableSetValueForKey:@"locations"];
    NSMutableSet *alarms = [task mutableSetValueForKey:@"alarms"];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts = [context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *task in fetchedProducts)
    {
        [context deleteObject:task];
    }
    NSNumber *isDone = [[NSNumber alloc] initWithBool:task.isDone];
    NSNumber *isLiked = [[NSNumber alloc] initWithBool:NO];
    
    taskObject = [NSEntityDescription insertNewObjectForEntityForName:@"TaskC" inManagedObjectContext:context];
    [taskObject setValue:task.title forKey:@"title"];
    [taskObject setValue:task.content forKey:@"content"];
    [taskObject setValue:task.date forKey:@"date"];
    [taskObject setValue:isLiked forKey:@"isLiked"];
    [taskObject setValue:0 forKey:@"hasAlert"];
    [taskObject setValue:isDone forKey:@"isDone"];
    [taskObject setValue:task.idTak forKey:@"idTak"];
    
    [taskObject setValue:alarms forKey:@"alarms"];
    [taskObject setValue:locations forKey:@"locations"];
    [taskObject setValue:attachments forKey:@"attachments"];
    
    NSPredicate *p2 = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p2];
    NSArray *updatedTaskArray = [context executeFetchRequest:fetch error:&fetchError];
    TaskC *updatedTask = (TaskC *)[updatedTaskArray firstObject];
    
    
    [self saveContext];
    return updatedTask;
}
-(void)addNewTaskWithTitle:(NSString *)title
                   content:(NSString *)content
                      date:(NSDate *)date
                   isLiked:(bool)liked
                    isDone:(bool)isDone
                    withID:(NSString *)generatedID
{
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *entiry;
        NSNumber *done = [[NSNumber alloc] initWithBool:isDone];
        NSNumber *isLiked = [[NSNumber alloc] initWithBool:liked];
    
        entiry = [NSEntityDescription insertNewObjectForEntityForName:@"TaskC" inManagedObjectContext:context];
        [entiry setValue:title forKey:@"title"];
        [entiry setValue:content forKey:@"content"];
        [entiry setValue:date forKey:@"date"];
        [entiry setValue:isLiked forKey:@"isLiked"];
        [entiry setValue:done forKey:@"isDone"];
        [entiry setValue:generatedID forKey:@"idTak"];
    
        [self saveContext];
}
-(void)addAlarmWithTitle:(NSString *)title
                    time:(NSDate *)time
                     set:(bool)set
           managedObject:(NSManagedObject *)object
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entityAlarm = [NSEntityDescription entityForName:@"AlarmC" inManagedObjectContext:context];
    NSManagedObject *newAlarm = [[NSManagedObject alloc] initWithEntity:entityAlarm insertIntoManagedObjectContext:context];
    [newAlarm setValue:title forKey:@"alarmTitle"];
    [newAlarm setValue:time forKey:@"alarmDate"];
    NSNumber *isSet = [[NSNumber alloc] initWithBool:set];
    [newAlarm setValue:isSet forKey:@"isSet"];
    NSMutableSet *alarms = [object mutableSetValueForKey:@"alarms"];
    [alarms addObject:newAlarm];
    [self saveContext];
}
-(void)deleteAlarm:(NSManagedObject *)object
{
    NSManagedObject *aManagedObject = object;
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:aManagedObject];
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
}
-(void)deleteTask:(TaskC *)task
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts = [context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *task in fetchedProducts)
    {
        [context deleteObject:task];
    }
    [self saveContext];
}
-(void)updateTask:(TaskC *)task
        withTitle:(NSString *)title
          content:(NSString *)content
             date:(NSDate *)date
          isLiked:(bool)liked
           isDone:(bool)isDone
           withID:(NSString *)generatedID
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *taskObject = task;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TaskC" inManagedObjectContext:context];
    NSMutableSet *attachments = [task mutableSetValueForKey:@"attachments"];
    NSMutableSet *locations = [task mutableSetValueForKey:@"locations"];
    NSMutableSet *alarms = [task mutableSetValueForKey:@"alarms"];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entity];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"idTak == %@", task.idTak];
    [fetch setPredicate:p];
    NSError *fetchError;
    NSArray *fetchedProducts = [context executeFetchRequest:fetch error:&fetchError];
    for (NSManagedObject *task in fetchedProducts)
    {
        [context deleteObject:task];
    }
    NSNumber *done = [[NSNumber alloc] initWithBool:isDone];
    NSNumber *isLiked = [[NSNumber alloc] initWithBool:liked];
    
    taskObject = [NSEntityDescription insertNewObjectForEntityForName:@"TaskC" inManagedObjectContext:context];
    [taskObject setValue:task.title forKey:@"title"];
    [taskObject setValue:task.content forKey:@"content"];
    [taskObject setValue:task.date forKey:@"date"];
    [taskObject setValue:isLiked forKey:@"isLiked"];
 
    [taskObject setValue:done forKey:@"isDone"];
    [taskObject setValue:task.idTak forKey:@"idTak"];
    [taskObject setValue:alarms forKey:@"alarms"];
    [taskObject setValue:locations forKey:@"locations"];
    [taskObject setValue:attachments forKey:@"attachments"];
    
    [self saveContext];
}
@end
