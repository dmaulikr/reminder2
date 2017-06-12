//
//  NoteCell.h
//  reminder
//
//  Created by Nikola on 6/6/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"




@interface NoteCell : UITableViewCell

-(NoteCell *)loadCell:(UITableViewCell *)cell task:(Task *)task;

@property (nonatomic, copy) void(^actionNoteChecked)(void);
@property (copy) void (^blockProperty)(void);



//@property (nonatomic, weak) id<MainViewControllerDelegate>  delegate;

-(void)checkBtnPresserd;



//#import
//
//@class MyClass;             //define class, so protocol can see MyClass
//@protocol MyClassDelegate   //define delegate protocol
//- (void) myClassDelegateMethod: (MyClass *) sender;  //define delegate method to be implemented within another class
//@end //end protocol
//
//@interface MyClass : NSObject {
//}
//@property (nonatomic, weak) id  delegate; //define MyClassDelegate as delegate
//
//@end


@end

