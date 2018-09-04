//
//  NSObject+Annotation.h
//  OPAnnotation
//
//  Created by 温杰 on 2018/8/31.
//  Copyright © 2018年 温杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Annotation)
-(id)getClsAnnationObjectForAnnationCls:(Class)annationCls;
-(id)getPropertyAnnationObjectForPropertyName:(NSString *)propertyName AndAnnationCls:(Class)annCls;
@end
