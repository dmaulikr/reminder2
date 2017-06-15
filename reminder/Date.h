//
//  Date.h
//  reminder
//
//  Created by Nikola on 6/15/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Date : NSObject
+(NSString*)timeSince:(NSDate*)date;;
+(NSDateFormatter *)getDateForrmater:(NSString *)name;
@end
