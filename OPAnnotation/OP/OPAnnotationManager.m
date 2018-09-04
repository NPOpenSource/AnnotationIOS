//
//  OPAnnotationManager.m
//  OPAnnotation
//
//  Created by 温杰 on 2018/8/31.
//  Copyright © 2018年 温杰. All rights reserved.
//

#import "OPAnnotationManager.h"
#import "OPHead.h"


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

@interface OPAnnotationManager()
@property (nonatomic,strong) NSMutableDictionary *annationClsDic;
@property (nonatomic,strong) NSMutableDictionary * annationPropertyDic;
@property (nonatomic,strong) NSMutableDictionary * annationMethodDic;
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
        self.annationPropertyDic = [NSMutableDictionary dictionary];
        self.annationMethodDic = [NSMutableDictionary dictionary];
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
    
    OPBaseAnnotation* ann=  [[annotationCls alloc]init];
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

-(id)getAnotionObjectForClass:(Class)cls Annotation:(Class)annotation{
    NSString * clsStr =   NSStringFromClass(cls);
    NSMutableSet * set= [self.annationClsDic objectForKey:clsStr];
    __block OPBaseAnnotation * ann = nil;
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:annotation.class]) {
            *stop = YES;
            ann = obj;
        }
    }];
    return ann;
}

#pragma mark - 属性方法注解
///属性注解
-(void)addClassPropertyName:(NSString * )propertyName Class:(Class)cls AnnotationCls:(Class )annCls annotationParams:(NSDictionary *)params{
    NSString * clsStr =   NSStringFromClass(cls);
    NSMutableDictionary * clsDic= [self.annationPropertyDic objectForKey:clsStr];
    if (!clsDic) {
        clsDic= [NSMutableDictionary new];
        [self.annationPropertyDic setObject:clsDic forKey:clsStr];
    }
    
    NSMutableSet * propertySet = [clsDic objectForKey:propertyName];
    if (!propertySet) {
        propertySet = [NSMutableSet new];
        [clsDic setObject:propertySet forKey:propertyName];
    }

    OPBaseAnnotation* ann=  [[annCls alloc]init];
    if (!((ann.getAnnotationQualifiedType & OPAnnotationQualifiedProperty)==OPAnnotationQualifiedProperty)) {
         OPLog(@"OPAnnotation:   Annation %@ not qualified class %@ Property %@",ann,clsStr,propertyName);
        return;
    }
    for (NSString * key in params) {
        @try {
            [ann setValue:params[key] forKey:key];
        } @catch (NSException *exception) {
            OPLog(@"OPAnnotation: 类 %@ 属性%@ Annation %@ not key %@",clsStr,propertyName,annCls,key);
        } @finally {
            
        }
        
    }
    if (ann.build) {
        ann.build(cls);
    }
    [propertySet addObject:ann];
}

-(id)getPropertyObjectForPropertyName:(NSString * )propertyName Class:(Class)cls AnnotationCls:(Class )annCls{
    NSString * clsStr =   NSStringFromClass(cls);
    NSSet * set =  [[self.annationPropertyDic objectForKey:clsStr] objectForKey:propertyName];
    __block OPBaseAnnotation * ann = nil;
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:annCls.class]) {
            *stop = YES;
            ann = obj;
        }
    }];
    return ann;

}

#pragma mark - 方法注解
///增加一条方法注解
-(void)addClassMethodSel:(SEL)Method andClass:(Class)cls andAnnotationCls:(Class )annCls andAnnotationParams:(NSDictionary *)params{
    NSString * clsStr =   NSStringFromClass(cls);
    NSMutableDictionary * clsDic= [self.annationMethodDic objectForKey:clsStr];
    if (!clsDic) {
        clsDic= [NSMutableDictionary new];
        [self.annationMethodDic setObject:clsDic forKey:clsStr];
    }
    
    NSString * selName = NSStringFromSelector(Method);
    NSMutableSet * methodSet = [clsDic objectForKey:selName];
    if (!methodSet) {
        methodSet = [NSMutableSet new];
        [clsDic setObject:methodSet forKey:selName];
    }
    
    OPBaseAnnotation* ann=  [[annCls alloc]init];
    if (!((ann.getAnnotationQualifiedType & OPAnnotationQualifiedProperty)==OPAnnotationQualifiedMethod)) {
        OPLog(@"OPAnnotation:   Annation %@ not qualified class %@ method %@",ann,clsStr,selName);
        return;
    }
    for (NSString * key in params) {
        @try {
            [ann setValue:params[key] forKey:key];
        } @catch (NSException *exception) {
            OPLog(@"OPAnnotation: 类 %@ method %@ Annation %@ not key %@",clsStr,selName,annCls,key);
        } @finally {
            
        }
    }
    if (ann.build) {
        ann.build(cls);
    }
    [methodSet addObject:ann];
}
///获取一条方法注解
-(id)getMethodObjectForMethodSel:(SEL)Method andClass:(Class)cls andAnnotationCls:(Class )annCls{
    NSString * clsStr =   NSStringFromClass(cls);
    NSString * selName = NSStringFromSelector(Method);
    NSSet * set =  [[self.annationMethodDic objectForKey:clsStr] objectForKey:selName];
    __block OPBaseAnnotation * ann = nil;
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:annCls.class]) {
            *stop = YES;
            ann = obj;
        }
    }];
    return ann;}


#pragma mark - private


@end
