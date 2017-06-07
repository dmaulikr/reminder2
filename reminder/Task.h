//
//  Task.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject



@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *dateString;

@property (assign) BOOL isLiked;
@property (assign) BOOL isDone;
//-(instancetype)init;

@end