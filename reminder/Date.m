//
//  Date.m
//  reminder
//
//  Created by Nikola on 6/15/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Date.h"

@implementation Date
+(NSString*)timeSince:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *newDate = date;
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSDate *currDate = [NSDate date];
    int dif = [currDate timeIntervalSinceReferenceDate] - [newDate timeIntervalSinceReferenceDate];
    NSString *timeSinceString = [[NSString alloc] init];
    if (dif<86400)
    {
        timeSinceString = [NSString stringWithFormat:@"Today"];
    }
    else
    {
        dif = (dif/86400);
        if (dif==1)
        {
            timeSinceString = @"Yesterday";
        }
        else{
            timeSinceString = [dateFormatter stringFromDate:newDate];
        }
    }
    return timeSinceString;
}
+(NSDateFormatter *)getDateForrmater:(NSString *)name
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if ([name isEqualToString:@"addNew"])
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    else if ([name isEqualToString:@"addToCoreData"])
    {
        [formatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    else if ([name isEqualToString:@"alarm"])
    {
        [formatter setDateFormat:@"HH:mm"];
    }
    else if ([name isEqualToString:@"allNotesCell"])
    {
        [formatter setDateFormat:@"MM-dd-yyyy HH:mm"];
    }
    else if ([name isEqualToString:@"sort"])
    {
        [formatter setDateFormat:@"dd/MM/yyyy"];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    return formatter;
    
}

@end
