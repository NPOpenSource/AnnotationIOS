//
//  OPVCAnnotion.h
//  OPAnnotation
//
//  Created by 温杰 on 2018/9/4.
//  Copyright © 2018年 温杰. All rights reserved.
//

#import "OPBaseAnnotation.h"

@interface OPVCAnnotion : OPBaseAnnotation
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSString *name;
+(NSSet *)getVCWithType:(NSString *)type;
@end
