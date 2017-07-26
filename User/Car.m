//
//  Car.m
//  User
//
//  Created by Dry on 2017/7/26.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "Car.h"

@implementation Car

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.color forKey:@"color"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.color = [aDecoder decodeObjectForKey:@"color"];
    }
    return self;
}

@end
