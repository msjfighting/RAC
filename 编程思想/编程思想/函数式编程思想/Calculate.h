//
//  Calculate.h
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Calculate : NSObject
@property (nonatomic,assign) int  result;

- (instancetype)calculate:(int (^)(int))calculateBlock;
@end

NS_ASSUME_NONNULL_END
