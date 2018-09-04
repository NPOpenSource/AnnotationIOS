//
//  OPAnnotationManager.h
//  OPAnnotation
//
//  Created by 温杰 on 2018/8/31.
//  Copyright © 2018年 温杰. All rights reserved.
//

#import <Foundation/Foundation.h>

//##__VA_ARGS__  '##'的意思是，如果可变参数被忽略或为空，将使预处理器（ preprocessor ）去除掉它前面的那个逗号。


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

///属性注解
#define OPPropertyAnnotation(ClassA,PropertyA,AnnotionClassA,...) __OPPropertyAnnotation(ClassA,PropertyA,AnnotionClassA,##__VA_ARGS__,10,9,8,7,6,5,4,3,2,1,0)

#define __OPPropertyAnnotation(ClassA,PropertyA,AnnotionClassA,_1, _2,_3,_4,_5,_6,_7,_8,_9,_10, N, ...) \
void __attribute__ ((constructor)) OPPropertyAnnotation##ClassA##PropertyA##AnnotionClassA##func(){  \
NSDictionary *params=nil;\
if (N==""){\
}else{\
params =__OPAnnotationParams(_1,_2,_3,_4,_5,_6,_7,_8,_9,_10,N);\
}\
NSString * propertystr =@(({const char *propertyC= #PropertyA; propertyC; })); \
[[OPAnnotationManager shareOPAnnotationManager] addClassPropertyName:propertystr Class:ClassA.class AnnotationCls:AnnotionClassA.class annotationParams:params];\
\
}


///方法注解
#define OPMethodAnnotation(ClassA,MethodA,AnnotionClassA,...) OPMethodAnnotationLine(__LINE__,ClassA,MethodA,AnnotionClassA,__VA_ARGS__)

#define OPMethodAnnotationLine(__LINE__,ClassA,MethodA,AnnotionClassA,...) __OPMethodAnnotation(__LINE__,ClassA,MethodA,AnnotionClassA,__VA_ARGS__,10,9,8,7,6,5,4,3,2,1)

#define __OPMethodAnnotation(__LINE__,ClassA,MethodA,AnnotionClassA,_1, _2,_3,_4,_5,_6,_7,_8,_9,_10, N, ...) \
void __attribute__ ((constructor)) OPMethodAnnotation##ClassA##__LINE__##AnnotionClassA##func(){  \
char * s = #_1; \
NSDictionary *params=nil;\
if (s==""){\
}else{\
id param1 = _1;\
params =__OPAnnotationParams(param1, _2,_3,_4,_5,_6,_7,_8,_9,_10,N);\
}\
}




#define __OPAnnotationParams(_1, _2,_3,_4,_5,_6,_7,_8,_9,_10, N) __OPGetAnnotationParamsDic(N, _1, _2,_3,_4,_5,_6,_7,_8,_9,_10)
extern NSDictionary  * __OPGetAnnotationParamsDic(NSUInteger count, ...);


#define OPPropertyKeyPath(KEYPATH) \
@(((void)(NO && ((void)KEYPATH, NO)), \
({ const char *opPropertykeypath = strchr(#KEYPATH, '.'); NSCAssert(opPropertykeypath, @"Provided key path is invalid."); opPropertykeypath+1; })))



@interface OPAnnotationManager : NSObject
+(OPAnnotationManager *)shareOPAnnotationManager;
///类注解

///增加一个类注解
-(void)addClass:(Class)cls AnnotationCls:(Class)annotation annotationParams:(NSDictionary *)params;
///获取一条类注解
-(id)getAnotionObjectForClass:(Class)cls Annotation:(Class) annotation;

///增加一条属性注解
-(void)addClassPropertyName:(NSString * )propertyName Class:(Class)cls AnnotationCls:(Class )annCls annotationParams:(NSDictionary *)params;
///获取一条属性注解
-(id)getPropertyObjectForPropertyName:(NSString * )propertyName Class:(Class)cls AnnotationCls:(Class )annCls;



///增加一条方法注解
-(void)addClassMethodSel:(SEL)Method andClass:(Class)cls andAnnotationCls:(Class )annCls andAnnotationParams:(NSDictionary *)params;
///获取一条方法注解
-(id)getMethodObjectForMethodSel:(SEL)Method andClass:(Class)cls andAnnotationCls:(Class )annCls;
@end
