//
//  NSObject+Calculate.h
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculateManger.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Calculate)
- (int)msj_makeCalculate:(void(^)(CalculateManger *))block;
@end

NS_ASSUME_NONNULL_END
