//
//  FlagModel.m
//  RAC
//
//  Created by zlhj on 2019/3/26.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "FlagModel.h"

@implementation FlagModel
+ (instancetype)flagWithDict:(NSDictionary *)dict{
    FlagModel *flag = [self alloc];
    
    [flag setValuesForKeysWithDictionary:dict];
    
    return flag;
}
@end
