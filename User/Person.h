//
//  Person.h
//  User
//
//  Created by Dry on 2017/7/26.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"

typedef NS_ENUM(NSInteger,Gender){
    GenderMan=1,
    GenderWoman
};

@interface Person : NSObject<NSCoding>//归档解档需要遵守NSCopying协议

@property (nonatomic, copy  ) NSString   *name;//姓名
@property (nonatomic        ) Gender     gender;//性别
@property (nonatomic        ) NSUInteger age;//年龄
@property (nonatomic        ) BOOL       isAdult;//是否成年
@property (nonatomic, strong) NSArray    *labelArray;//性格标签数组

@property (nonatomic, strong) Car        *car;

// 归档地址
+ (NSString *)archivePath;

@end
