//
//  NSObject+Annotation.m
//  OPAnnotation
//
//  Created by 温杰 on 2018/8/31.
//  Copyright © 2018年 温杰. All rights reserved.
//

#import "NSObject+OPAnnotation.h"
#import "OPAnnotationManager.h"
@implementation NSObject (OPAnnotation)
-(id)getClsAnnationObjectForAnnationCls:(Class)annationCls{
    return [[OPAnnotationManager shareOPAnnotationManager]getAnotionObjectForClass:self.class Annotation:annationCls];
}

-(id)getPropertyAnnationObjectForPropertyName:(NSString *)propertyName AndAnnationCls:(Class)annCls
{
    return [[OPAnnotationManager shareOPAnnotationManager]getPropertyObjectForPropertyName:propertyName Class:self.class AnnotationCls:annCls];
}
@end
