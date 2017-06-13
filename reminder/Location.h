//
//  Location.h
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject <NSCoding>

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longnitude;

@end
