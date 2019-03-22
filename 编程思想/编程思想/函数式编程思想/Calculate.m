//
//  Calculate.m
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "Calculate.h"

@implementation Calculate
- (instancetype)calculate:(int (^)(int))calculateBlock{
    _result = calculateBlock(_result);
    return self;
}
@end
