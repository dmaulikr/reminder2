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
        
//        [newImage setValue:@"datePicker" forKey:@"attachmentID"];
        [newImage setValue:imagePath forKey:@"imgName"];
        
    
        NSMutableSet *attachments = [taskObject mutableSetValueForKey:@"attachments"];
        [attachments addObject:newImage];
        
        [self saveContext];
    
        //test
   
    
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
  
    NSLog(@"");
}
@end
