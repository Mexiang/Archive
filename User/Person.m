
//
//  Person.m
//  User
//
//  Created by Dry on 2017/7/26.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // 归档
    // 这里的Key为了方便和减少错误，最好就用属性作为Key
    // 不听类型的属性有不同的归档和解档方法

    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.gender forKey:@"gender"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeBool:self.isAdult forKey:@"isAdult"];
    [aCoder encodeObject:self.labelArray forKey:@"labelArray"];
    // 这里注意一下，归档一个对象的时候，这个对象也需要实现NSCoding协议和相应的方法，不然的话直接闪退，闪退日志如下：
    // -[Car encodeWithCoder:]: unrecognized selector sent to instance
    [aCoder encodeObject:self.car forKey:@"car"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        // 解档，赋值
        // 这里的Key需与归档时的Key一致
        
        self.name       = [aDecoder decodeObjectForKey:@"name"];
        self.gender     = [aDecoder decodeIntegerForKey:@"gender"];
        self.age        = [aDecoder decodeIntegerForKey:@"age"];
        self.isAdult    = [aDecoder decodeBoolForKey:@"isAdult"];
        self.labelArray = [aDecoder decodeObjectForKey:@"labelArray"];
        self.car        = [aDecoder decodeObjectForKey:@"car"];
    }
    return self;
}

// 归档地址
+ (NSString *)archivePath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingString:@"PersonCache"];
}

- (Car *)car {
    if (!_car) {
        _car = [[Car alloc]init];
    }
    return _car;
}

@end
