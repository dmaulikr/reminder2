//
//  TasksUpdater.h
//  reminder
//
//  Created by Nikola on 6/9/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NoteCell;
@protocol TaskUpdateDelegate
- (void)getRowIndex;

@end

@interface TasksUpdater : NSObject

@property (nonatomic, weak) id  delegate;

- (void)updaterUpdateRow;


@end
