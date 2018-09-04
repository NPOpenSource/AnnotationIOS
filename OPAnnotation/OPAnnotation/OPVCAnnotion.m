//
//  OPVCAnnotion.m
//  OPAnnotation
//
//  Created by 温杰 on 2018/9/4.
//  Copyright © 2018年 温杰. All rights reserved.
//

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
