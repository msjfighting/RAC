//
//  NSObject+KVO.m
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "NSObject+KVO.h"
#import <objc/message.h>
#import "MSJKVONotifying_Person.h"
// 全局
NSString * const observerKey = @"observer";
@implementation NSObject (KVO)
- (void)msj_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context
{
    // 把观察者保存到当前对象
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(observerKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 修改isa指针(runtime)
    object_setClass(self, [MSJKVONotifying_Person class]);
}
@end
