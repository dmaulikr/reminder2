//
//  Colors.m
//  reminder
//
//  Created by Nikola on 6/7/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+ (UIColor *)gray {
    return [UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f];
}
+ (UIColor *)lightGray {
    return [UIColor colorWithRed:235.0f/255.0f green:230.0f/255.0f blue:246.0f/255.0f alpha:1.0f];
}
+ (UIColor *)darkColor {
    return [UIColor colorWithRed:222.0f/255.0f green:210.0f/255.0f blue:131.0f/255.0f alpha:1.0f];
}
+ (UIColor *)yellowTask {
    return [UIColor colorWithRed:243.0f/255.0f green:229.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
}
+ (UIColor *)redColor {
    return [UIColor colorWithRed:255.0f/255.0f green:107.0f/255.0f blue:105.0f/255.0f alpha:1.0f];
}

@end
