//
//  ViewController.m
//  User
//
//  Created by Dry on 2017/7/21.
//  Copyright © 2017年 Dry. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

#define kChachArrayPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"MyArray"]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Person *person    = [[Person alloc]init];
    person.name       = @"小明";
    person.age        = 23;
    person.gender     = GenderMan;
    person.isAdult    = YES;
    person.labelArray = @[@"阳光",@"萌新",@"正太"];
    person.car.color  = [UIColor blackColor];
    
    // 归档Person对象
    [NSKeyedArchiver archiveRootObject:person toFile:[Person archivePath]];
    
    // 归档一个数组
    NSArray *array = @[@"阳光",@"萌新",@"正太"];
    [NSKeyedArchiver archiveRootObject:array toFile:kChachArrayPath];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 接档Person属性，并打印
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:[Person archivePath]];
    NSLog(@"%@",person.name);
    NSLog(@"%ld",person.age);
    NSLog(@"%ld",person.gender);
    NSLog(@"%d",person.isAdult);
    NSLog(@"%@",person.labelArray);
    NSLog(@"%@",person.car.color);
    
    // 解档一个数组
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:kChachArrayPath];
    NSLog(@"%@",array[0]);
}



@end
