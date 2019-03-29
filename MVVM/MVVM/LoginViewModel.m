//
//  LoginViewModel.m
//  MVVM
//
//  Created by zlhj on 2019/3/29.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel
-(instancetype)init{
    if (self = [super init]) {
        [self setUp];
    }
    return self;
}
// 最好不要包括视图V
- (void)setUp{
    // 处理登录点击信号
    // 只要对象的属性一改变就会产生信号
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self,userName ), RACObserve(self, pwd)] reduce:^id _Nonnull{
        return @(self->_userName.length && self->_pwd.length);
    }];
    
    // 处理登录的点击命令
    _loginComm = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"传入的参数: %@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            [mgr GET:@"https://www.apiopen.top/createUser?key=00d91e8e0cca2b76f515926a36db68f5" parameters:@{@"phone":self->_userName,@"passwd":self->_pwd} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
                NSLog(@"%@",responseObject);
                // 发送数据
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                // 发送数据
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
    
    // 第一次时 还没开始执行
    [[_loginComm.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
            [YJProgressHUD showProgress:@"" inView:Window];
        }else{
            NSLog(@"执行完成");
            [YJProgressHUD hide];
        }
    }];
    
    
    // 处理登录请求返回的结果
    [_loginComm.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"返回的参数%@",x);
    }];
    
}
@end
