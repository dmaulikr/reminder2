//
//  Task.m
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Task.h"

@implementation Task

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.attachmentsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.idTask forKey:@"idTitle"];
    [aCoder encodeObject:self.title forKey:@"titleTask"];
    [aCoder encodeObject:self.content forKey:@"contentTask"];
    [aCoder encodeObject:self.date forKey:@"dateTask"];
    [aCoder encodeObject:self.dateString forKey:@"dateStringTask"];
    [aCoder encodeObject:self.imageString forKey:@"imageStringTask"];
    [aCoder encodeObject:self.attachmentsArray forKey:@"attachmentsArray"];
    [aCoder encodeObject:self.alertDate forKey:@"alertDate"];
    [aCoder encodeObject:self.locationAttachment forKey:@"locationAttachment"];
    [aCoder encodeObject:self.taskAlarm forKey:@"taskAlarm"];
    [aCoder encodeObject:self.alarmsArray forKey:@"alarmsArray"];

    [aCoder encodeBool:self.isDone forKey:@"isTaskDone"];
    [aCoder encodeBool:self.isLiked forKey:@"isTaskLiked"];
    [aCoder encodeBool:self.hasAlert forKey:@"taskHasAlert"];
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        
        self.idTask = [aDecoder decodeObjectForKey:@"idTitle"];
        self.title = [aDecoder decodeObjectForKey:@"titleTask"];
        self.content = [aDecoder decodeObjectForKey:@"contentTask"];
        self.date = [aDecoder decodeObjectForKey:@"dateTask"];
        self.dateString = [aDecoder decodeObjectForKey:@"dateStringTask"];
        self.imageString = [aDecoder decodeObjectForKey:@"imageStringTask"];
        self.attachmentsArray = [aDecoder decodeObjectForKey:@"attachmentsArray"];
        self.alertDate = [aDecoder decodeObjectForKey:@"alertDate"];
        self.locationAttachment = [aDecoder decodeObjectForKey:@"locationAttachment"];
        self.taskAlarm = [aDecoder decodeObjectForKey:@"taskAlarm"];
        self.alarmsArray = [aDecoder decodeObjectForKey:@"alarmsArray"];
        
        self.isDone = [aDecoder decodeBoolForKey:@"isTaskDone"];
        self.isLiked = [aDecoder decodeBoolForKey:@"isTaskLiked"];
        self.hasAlert = [aDecoder decodeBoolForKey:@"isTaskDone"];
        
    }
    return self;
}

@end
