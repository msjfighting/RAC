//
//  ViewController.m
//  MVVM
//
//  Created by zlhj on 2019/3/29.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewModel.h"
#import "RequestViewModel.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *pwd;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (nonatomic,strong) LoginViewModel * viewmodel;
@end

@implementation ViewController
- (IBAction)btnClick:(id)sender {
}
- (LoginViewModel *)viewmodel{
    if (_viewmodel == nil) {
        _viewmodel = [[LoginViewModel alloc] init];
    }
    return _viewmodel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // MVVM: 先创建vm模型,把整个界面的一些业务逻辑处理完   回到控制器去执行
    
    //给视图模型绑定账号,密码绑定信号
    RAC(self.viewmodel,userName) = _username.rac_textSignal;
    RAC(self.viewmodel,pwd) = _pwd.rac_textSignal;
    RAC(_btn,enabled) = self.viewmodel.loginEnableSignal;
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [self.viewmodel.loginComm execute:@"000"];
        
    }];
    
    RequestViewModel * vm = [[RequestViewModel alloc] init];
    // 处理请求返回的结果
    [[vm.loginComm execute:@"111"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

- (void)mvc{
    RACSignal *loginEnableSignal = [RACSignal combineLatest:@[_username.rac_textSignal, _pwd.rac_textSignal] reduce:^id _Nonnull{
        return @(self->_username.text.length && self->_pwd.text.length);
    }];
    RAC(_btn,enabled) = loginEnableSignal;
    
    RACCommand *comm = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 发送数据
            [subscriber sendNext:@"222"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    
    // 第一次时 还没开始执行
    [[comm.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            NSLog(@"正在执行");
            [YJProgressHUD showProgress:@"" inView:self.view];
        }else{
            NSLog(@"执行完成");
            [YJProgressHUD hide];
        }
    }];
    
    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        [[comm execute:@"1"] subscribeNext:^(id  _Nullable x) {
            NSLog(@"按钮被点击了%@",x);
        }];
    }];
}
@end
