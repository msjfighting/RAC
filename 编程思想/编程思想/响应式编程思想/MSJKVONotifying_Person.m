//
//  MSJKVONotifying_Person.m
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "MSJKVONotifying_Person.h"
#import <objc/message.h>
extern NSString * const observerKey;
@implementation MSJKVONotifying_Person
- (void)setName:(NSString *)name{
    [super setName:name];
    // 通知观察者 observeValueForKeyPath
    
    // 获取观察者
    NSObject * observer = objc_getAssociatedObject(self, observerKey);
    // 通知观察者
    [observer observeValueForKeyPath:@"name" ofObject:self change:nil context:nil];
}
@end
