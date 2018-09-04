\经常听android的同事说注解，说这个技术真好用。好奇心之下，我也搜索了下ios的注解。完蛋，ios的注解大多数都是讲怎么注释的，根本没有注解。我就在想我们ios上能不能也实现注解这个功能呢？想实现这个功能，我们必须要懂得注解是个什么东西才行，因此我就询问同事和网上查资料，弄懂了注解到底是个啥东西。

# 注解
android 注解的解释
>注解(Annotaion)，也叫元数据。一种代码级别的说明。它是JDK1.5及以后版本引入的一特性，与类、接口、枚举是在同一个层次。它可以声明在包、类、字段、方法、局部变量、方法参数等的前面，用来对这些元素进行说明、注解。

在我看来注解就是一个标签。用来标示类、字段、方法等的特性。

# 注解分类
根据声明周期，android的注解分为三类
+ 源代码注解 
+ 编译时注解
+ 运行时注解

### 源代码注解 
主要作用是编译检查。
> 在编译代码之前就让编译器给你查阅代码的合法性,相当于ios上的类型检查。这个注解在编译阶段就没用了。
这个暂时没想到办法能实现帮助编译器做校验。

### 编译时注解
> 在编译阶段让编译器主动帮助我们生成一些类，而不用我们自己编写这些类，我们只要告诉编译器如何编译这个类就行了。这个注解在编译结束后已经生成了我们所需要的代码。

### 运行时注解 
> 在运行时，我们可以获取类，方法，属性等我们给其打的注解（标签），这个在程序启动的时候帮助我们绑定类，方法，属性。

以上是个人理解。不对的请各路大神指正。

从上面这几种注解中，**源代码注解**，我目前是没有一点想实现的想法（无从下手）。**编译时注解**，是在程序编译阶段帮助我们自动生成一些文件添加到工程里面，这个需要编译器去做，貌似也做不了。能力所限，剩下的只能做个**运行时注解**了。

#运行时注解

场景一：我们创建TableView， 有三项，每项都应一个vc跳转，如果我们新增加一项或者删除一项，我们就需要修改TableView,所在文件的代码。
如下
```
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray  *datasource;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   UITableView * table= [[UITableView alloc]initWithFrame: [UIScreen mainScreen].bounds style:0];
    table.delegate = self;
    table.dataSource = self;
    self.datasource = [NSMutableArray array];
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"vc"];
    [self.datasource addObject:[[OPFirstViewController alloc]init]];
    [self.datasource addObject:[[OPTwoViewController alloc]init]];
     [self.datasource addObject:[[OPThirdViewController alloc]init]];
    [self.view addSubview:table];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"vc"];
    if (cell) {
        cell.textLabel.text = NSStringFromClass([[self.datasource objectAtIndex:indexPath.row] class]);
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self presentViewController:[self.datasource objectAtIndex:indexPath.row] animated:YES completion:^{
        
    }];
}
```
![image.png](https://upload-images.jianshu.io/upload_images/1682758-a55ec5b8c2f3f598.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如果我们需要再新增一个类** OPFourViewController**，我们需要改动代码如下
```
#import "OPFourViewController.h"
 [self.datasource addObject:[[OPFourViewController alloc]init]];
```
![image.png](https://upload-images.jianshu.io/upload_images/1682758-6c3910680db13e20.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
上面的写法肯定没有问题。


那用运行时注解怎么做呢？
我们创建一个注解类
```
#import "OPBaseAnnotation.h"

@interface OPVCAnnotion : OPBaseAnnotation
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *name;
+(NSSet *)getVCWithType:(NSString *)type;
@end

#import "OPVCAnnotion.h"
static NSMutableDictionary * vcDic;

@implementation OPVCAnnotion

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
-(OPAnnotationQualifiedType)getAnnotationQualifiedType{
    return OPAnnotationQualifiedClass;
}

+(NSSet *)getVCWithType:(NSString *)type{
    if (!vcDic) {
        return nil;
    }
    NSDictionary * dicName = [vcDic objectForKey:@"type"];
    
    if (dicName) {
        return  [dicName objectForKey:type];
    }
    return nil;
}

-(OPBaseAnnotation *(^)(id))build{
    return ^OPBaseAnnotation*(id object){
        if (!self.type) {
            return self;
        }
        if (!vcDic) {
            vcDic = [NSMutableDictionary dictionary];
        }
        //       self.name
        NSMutableDictionary * clsDic = [vcDic   objectForKey:@"type"];
        if (!clsDic) {
            clsDic = [NSMutableDictionary new];
            [vcDic setObject:clsDic forKey:@"type"];
        }
        
        NSMutableSet * set = [clsDic objectForKey:self.type];
        if (!set) {
            set = [NSMutableSet new];
            [clsDic setObject:set forKey:self.type];
        }
        [set addObject:object];
        
        return self;
    };
}

@end
```
我们在每个类的.m 文件中加入我们需要的注解
```
#import "OPFirstViewController.h"

#import "OPHead.h"
#import "OPVCAnnotion.h"
OPClassAnnotation(OPFirstViewController, OPVCAnnotion,@"type=UI",@"name=firstVC");

@interface OPFirstViewController ()

@end

@implementation OPFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
```
调用
```
   NSSet * set =  [OPVCAnnotion getVCWithType:@"UI"];
    for (Class cls in set) {
        [self.datasource addObject:[[cls.class alloc]init]];
    }
    
```
ok 运行项目
![image.png](https://upload-images.jianshu.io/upload_images/1682758-60f55869bdc7f7ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我们发现，我们再也不用关心TableView的 **dataSource**。
只要是我们给vc 添加了注解，我们就能从**OPVCAnnotion**中获取到。

# 运行时注解实现

我们知道注解相当于个标签，标签可以绑定类，属性或者方法。在运行的时候运行一段代码，因此这段代码只能在.m文件中了（.h文件不能有函数实现）。因此我们需要考虑的怎么在运行时将类，属性或者方法和标签进行绑定，并且是在程序运行的开始阶段就绑定。
> 第一种方案：是在+load 方法进行绑定。
> 第二种方案：是在__attribute__ ((constructor)) 标记的方法中绑定

这两种方案都是在程序启动，调用main函数之前调用的，我抛弃了第一种方案，因为+load 方法，大家有时候需要用的嘛。第二种方案随便命名，只要用__attribute__ ((constructor)) 标记就可以了。

因为需要类和注解之间绑定关系，我们这里采用单例类来记录类和注解之间的绑定关系。

关系图

![image.png](https://upload-images.jianshu.io/upload_images/1682758-72166e8d0812c2e7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

```
@interface OPAnnotationManager : NSObject
+(OPAnnotationManager *)shareOPAnnotationManager;
///类注解

///增加一个类注解
-(void)addClass:(Class)cls AnnotationCls:(Class)annotation annotationParams:(NSDictionary *)params;

@interface OPAnnotationManager()
@property (nonatomic,strong) NSMutableDictionary *annationClsDic;
@end
@implementation OPAnnotationManager
static OPAnnotationManager * manager = nil;
+(OPAnnotationManager *)shareOPAnnotationManager{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        manager = [[OPAnnotationManager alloc]init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.annationClsDic = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 类方法注解
-(void)addClass:(Class)cls AnnotationCls:(Class)annotation annotationParams:(NSDictionary *)params{
    NSString * clsStr =   NSStringFromClass(cls);
    NSMutableSet * set = [self.annationClsDic objectForKey:clsStr];
    if (!set) {
        set = [NSMutableSet set];
        [self.annationClsDic setObject:set forKey:clsStr];
    }
    Class annotationCls = annotation;
  ///如何实现 检查类型
    
    OPBaseAnnotation* ann=  [[annotationCls.class alloc]init];
    if (!((ann.getAnnotationQualifiedType & OPAnnotationQualifiedClass)==OPAnnotationQualifiedClass)) {
        OPLog(@"OPAnnotation:   Annation %@ not qualifiedClass %@",annotation,clsStr);

        return;
    }
    for (NSString * key in params) {
        @try {
            [ann setValue:params[key] forKey:key];
        } @catch (NSException *exception) {
            OPLog(@"OPAnnotation: 类 %@  Annation %@ not key %@",clsStr,annotation,key);
        } @finally {
            
        }    }
    if (ann.build){
        ann.build(cls);
    }
   
    [set addObject:ann];
}


typedef enum : NSUInteger {
    OPAnnotationQualifiedNone=0,
    OPAnnotationQualifiedClass=1<<1,
    OPAnnotationQualifiedProperty=1<<2,
    OPAnnotationQualifiedMethod=1<<3,
    OPAnnotationQualifiedMask=0x00FF,
} OPAnnotationQualifiedType;

@interface OPBaseAnnotation : NSObject
-(OPBaseAnnotation*(^)(id object))build;
-(OPAnnotationQualifiedType)getAnnotationQualifiedType;
@end

#import "OPBaseAnnotation.h"

@implementation OPBaseAnnotation
-(OPAnnotationQualifiedType)getAnnotationQualifiedType{
    return OPAnnotationQualifiedNone;
}

-(OPBaseAnnotation*(^)(id object))build{
    return ^(id object){
        return self;
    };
}



@end

```
上述是单例类的实现，这里我们还创建了个Annotation类，就是为了图中的那条虚线，我们可以通过类找到注解，我们也应该可以通过注解找到相关的类，我们将类给注解类，具体如何处理是我们自己的事情了。

如何添加注解呢？因为可能有多个参数传入，因此我们这里采用宏定义的方式进行处理
```
///类注解
#define  OPClassAnnotation(ClassA,AnnotionClassA,...) __OPClassAnnotation(ClassA,AnnotionClassA,##__VA_ARGS__,10,9,8,7,6,5,4,3,2,1,0)

#define __OPClassAnnotation(ClassA,AnnotionClassA,_1, _2,_3,_4,_5,_6,_7,_8,_9,_10, N, ...) \
void __attribute__ ((constructor)) OPclassAnnotation##ClassA##AnnotionClassA##func(){  \
NSDictionary *params=nil;\
if (N==0){\
}else{\
params =__OPAnnotationParams(_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,N);\
}\
[[OPAnnotationManager shareOPAnnotationManager] addClass:ClassA.class AnnotationCls:AnnotionClassA.class annotationParams:params];\
}
```
获取不定参数
```
NSDictionary  * __OPGetAnnotationParamsDic(NSUInteger count, ...) {
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    va_list args;
    va_start(args, count);
    for (NSUInteger x = 0; x < count; ++x){
        NSString * paramStr  = va_arg(args, id);
        NSArray * paramArr =  [paramStr componentsSeparatedByString:@"="];
        if (paramArr.count==2) {
            [paramDic setObject:paramArr[1] forKey:paramArr[0]];
        }
    }
    va_end(args);
    return paramDic;
}
```

因为实现起来不难，这里只是抛砖引玉，希望各种大牛真正实现ios的注解。

源码实现了属性 ，类和类方法的注解。

[源码地址](https://github.com/NPOpenSource/AnnotationIOS)




