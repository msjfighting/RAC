//
//  CalculateManger.m
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "CalculateManger.h"

@implementation CalculateManger
//- (id)add:(int)value{
//    _result += value;
//    return self;
//}
- (CalculateManger *(^)(int))add{
    __weak typeof(self) weakSelf = self;
    return ^(int value){
        weakSelf.result += value;
        return self;
    };
}
@end
