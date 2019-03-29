//
//  RequestViewModel.m
//  MVVM
//
//  Created by zlhj on 2019/3/29.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "RequestViewModel.h"

@implementation RequestViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}
- (void)setUp{
    _loginComm = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"传入的参数: %@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
            [mgr GET:@"https://www.apiopen.top/createUser?key=00d91e8e0cca2b76f515926a36db68f5" parameters:@{@"phone":@"14578549624",@"passwd":@"123456"} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                // 发送数据
                NSDictionary *dic = responseObject[@"data"];
               NSArray *arr = [[dic.rac_sequence map:^id _Nullable(id  _Nullable value) {
                    return [[NSObject alloc] init];
                }] array];
                [subscriber sendNext:arr];
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
}
@end
