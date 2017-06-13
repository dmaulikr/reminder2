//
//  Alarm.m
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Alarm.h"

@implementation Alarm
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.alarmTitle forKey:@"alarmTitle"];
    [aCoder encodeObject:self.date forKey:@"alarmDate"];
    [aCoder encodeBool:self.isSet forKey:@"isSet"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.alarmTitle = [aDecoder decodeObjectForKey:@"alarmTitle"];
        self.date = [aDecoder decodeObjectForKey:@"alarmDate"];
        self.isSet = [aDecoder decodeBoolForKey:@"isSet"];
    }
    return self;
}

@end
