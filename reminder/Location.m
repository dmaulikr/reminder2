//
//  Location.m
//  reminder
//
//  Created by Nikola on 6/12/17.
//  Copyright © 2017 Nikola. All rights reserved.
//

#import "Location.h"

@implementation Location

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.longnitude forKey:@"lognitude"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.longnitude = [aDecoder decodeObjectForKey:@"lognitude"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
    }
    return self;
}

@end
