//
//  OPBaseAnnotation.m
//  OPAnnotation
//
//  Created by 温杰 on 2018/8/31.
//  Copyright © 2018年 温杰. All rights reserved.
//

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
