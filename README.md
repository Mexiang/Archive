# Archive
Archive and UnArchive

## 关键词：
* 归档：数据持久化的一种方式，是将数据进行编码序列化之后存储的过程。适用于小量数据的存储。

* 解档：对归档的数据进行解码，拿到当初归档的数据的过程。

* NSCoding：A protocol that enables an object to be encoded and decoded for archiving and distribution.
一种能够对对象进行编码和解码，以实现归档和解档案的协议，也就是说只有遵循了NSCoding这个协议才能实现数据的归档和解档。
NSCoding 是一个简单的协议，通过 -initWithCoder: 和 encodeWithCoder:方法，遵循NSCoding协议的类可以被序列化和反序列化，这样可以将数据归档到磁盘上。

沙盒、Archiver 、encode、UnArchiver、decode、、NSCoder、NSKeyedArchiver、NSKeyedUnarchiver、NSKeyedArchiverDelegate、NSKeyedUnarchiverDelegate

归档的缺点：归档的形式来保存数据，只能一次性归档保存以及一次性解压。所以只能针对小量数据，而且对数据操作比较笨拙，即如果想改动数据的某一小部分，还是需要解压整个数据或者归档整个数据

## 实现过程
### 1、归档和解档一个对象
#### ViewController
ViewController.m
```
#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Person *person = [[Person alloc]init];
    person.name = @"小明";
    person.age = 23;
    person.gender = GenderMan;
    person.isAdult = YES;
    person.labelArray = @[@"阳光",@"萌新",@"正太"];
    person.car.color = [UIColor blackColor];
    
    // 归档Person对象
    [NSKeyedArchiver archiveRootObject:person toFile:[Person archivePath]];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 解档Person属性，并打印
    Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:[Person archivePath]];
    NSLog(@"%@",person.name);
    NSLog(@"%ld",person.age);
    NSLog(@"%ld",person.gender);
    NSLog(@"%d",person.isAdult);
    NSLog(@"%@",person.labelArray);
    NSLog(@"%@",person.car.color);
}
```
* 为了方便测试，我们直接在viewDidLoad创建了一个person对象，并给其属性赋了值，之后将person这个对象进行了归档。
* 在touch方法里面我们解档了person对象，然后将归档的属性值打印了出来。
* 这里需要注意一下，项目中根据情况，有时候归档和解档需要异步处理，自己添加子线程即可。

这个过程就实现了对一个对象的归档和解档，那么在Person类里面操作如下：

#### Person
Person.h
```
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
```
Person.m
```
#import "Person.h"

@implementation Person

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // 归档
    // 这里的Key为了方便和减少错误，最好就用属性作为Key
    // 不同类型的属性有不同的归档和解档方法

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
        
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.gender = [aDecoder decodeIntegerForKey:@"gender"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.isAdult = [aDecoder decodeBoolForKey:@"isAdult"];
        self.labelArray = [aDecoder decodeObjectForKey:@"labelArray"];
        self.car = [aDecoder decodeObjectForKey:@"car"];
    }
    return self;
}

// 归档地址
+ (NSString *)archivePath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [path stringByAppendingString:@"PersonCache"];
}

//通过get方法创建car对象，外部不再需要每次创建，直接使用点语法给car的属性赋值即可。
- (Car *)car {
    if (!_car) {
        _car = [[Car alloc]init];
    }
    return _car;
}
@end
```
* 这里的Person和Car是我们创建的两个类，算是两个Model。
* Person中有一些属性，特别的它有一个属性car。
* 归档需要 有一个归档的地址，我们直接用类方法返回一个归档路径。

#### Car
Car.h
```
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Car : NSObject<NSCoding>//Car也需要遵循NSCoding协议

@property (nonatomic, strong) UIColor *color;//汽车颜色

@end
```
Car.m
```
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
```
* Car有一个属性color，要想归档Person对象的car属性，则需要Car也遵循NSCoding协议，而且也需要实现自己的归档和解档方法。

到这里归档和解档一个对象的操作就完成了
#### 小结
总结一下归档一个对象需要以下几个步骤：
1、遵循NSCoding协议<NSCoding>
2、实现归档和解档的方法
 - (void)encodeWithCoder:(NSCoder *)aCoder
 - (nullable instancetype)initWithCoder:(NSCoder *)aDecoder

3、归档或者解档
```
// 归档Person
[NSKeyedArchiver archiveRootObject:person toFile:[Person archivePath]];
```
```
// 解档Person
Person *person = [NSKeyedUnarchiver unarchiveObjectWithFile:[Person archivePath]];
```

### 2、归档一个数组、字典等
与归档一个对象一样的原理，这里讲归档数组的地址写了一个宏。
```
//数组归档地址
#define kChachArrayPath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"MyArray"]
```
```
// 归档数组
NSArray *array = @[@"阳光",@"萌新",@"正太"];
[NSKeyedArchiver archiveRootObject:array toFile:kChachArrayPath];
```
```
// 解档数组
NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:kChachArrayPath];
NSLog(@"%@",array[0]);
```
这种只归档了一个数组的方式如果在项目中使用，建议不要这样用，因为不方便管理。推荐使用NSUserDefaults。根据具体的项目情况选择最合适的。

<http://www.jianshu.com/p/24856243d36a>

