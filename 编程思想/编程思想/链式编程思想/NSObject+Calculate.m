//
//  NSObject+Calculate.m
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "NSObject+Calculate.h"

@implementation NSObject (Calculate)
- (int)msj_makeCalculate:(void(^)(CalculateManger *))block{
    CalculateManger *mgr = [[CalculateManger alloc] init];
    block(mgr);
    return mgr.result;
}
@end
