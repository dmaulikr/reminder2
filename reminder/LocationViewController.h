//
//  LocationViewController.h
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"


@protocol LocationViewControllerDelegate <NSObject>


-(void)locationUpdated:(Location *)location
             imageDraw:(UIImage *)image;


@end
@interface LocationViewController : UIViewController

@property (weak, nonatomic) id<LocationViewControllerDelegate> delegate;
@property (strong, nonatomic) Location *location;

@end
