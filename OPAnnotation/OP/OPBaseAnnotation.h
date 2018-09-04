//
//  OPBaseAnnotation.h
//  OPAnnotation
//
//  Created by 温杰 on 2018/8/31.
//  Copyright © 2018年 温杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPHead.h"

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

