//
//  FlagModel.h
//  RAC
//
//  Created by zlhj on 2019/3/26.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlagModel : NSObject
@property (nonatomic,copy) NSString * key;
@property (nonatomic,copy) NSString * num;
+ (instancetype)flagWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
