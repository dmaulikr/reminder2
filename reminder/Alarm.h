//
//  Alarm.h
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alarm : NSObject <NSCoding>

@property (strong, nonatomic) NSString *alarmTitle;
@property (strong, nonatomic) NSDate *date;
@property (assign, atomic) BOOL isSet;

@end
