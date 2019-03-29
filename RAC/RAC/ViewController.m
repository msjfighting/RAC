//
//  ViewController.m
//  RAC
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "ViewController.h"
#import "Globe.h"
#import <ReactiveObjC/RACReturnSignal.h>
#import "RedView.h"
#import "FlagModel.h"
@interface ViewController ()
@property (nonatomic,strong)  id<RACSubscriber> subscriber;
@property (strong, nonatomic) IBOutlet RedView *redview;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITextField *pass;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;


@end

@implementation ViewController
- (IBAction)login:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self delegate1];
    
   // [self dict];
    
//    [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"按钮被点击了");
//    }];

  
  
 
}
- (void)skip{
    RACSubject *sub = [RACSubject subject];
    // 跳跃几次信号再订阅
    [[sub skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [sub sendNext:@"1"];
    [sub sendNext:@"2"];
    [sub sendNext:@"3"];
}
#pragma mark 如果当前的值给上一个值相同,就不会被订阅到
- (void)distinctUntilChanged{
    RACSubject *sub = [RACSubject subject];
    [[sub distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [sub sendNext:@"1"];
    [sub sendNext:@"2"];
    [sub sendNext:@"1"];
}
#pragma mark take
- (void)take{
    RACSubject *sub = [RACSubject subject];
    // 取前面几个值
    //    [[sub take:1] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"take %@",x);
    //    }];
    
    // 使用takeLast,必须使用发送完成sendCompleted
    //    [[sub takeLast:2] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"takeLast  %@",x);
    //    }];
    
    RACSubject *sig = [RACSubject subject];
    // takeUntil 只要传入的信号发送完成,就不会再接收源信号的内容
    [[sub takeUntil:sig]subscribeNext:^(id  _Nullable x) {
        NSLog(@"takeUntil   %@",x);
    }];
    
    [sub sendNext:@"1"];
    [sub sendNext:@"111222"];
    
    [sig sendCompleted];
    
    [sig sendNext:@"00"];
    
    // [sub sendCompleted];
}
#pragma mark ignore(忽略)
- (void)ignore{
    RACSubject *sub = [RACSubject subject];
    // ignore 忽略掉内容为1的信号
    [[sub ignore:@"1"] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [sub sendNext:@"1"];
    [sub sendNext:@"111222"];
}
#pragma mark 根据内容长度大于5,才获取内容(过滤)
- (void)filter{
    RACSignal *filter = [_userName.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        // value:源信号的内容
        if (value.length > 5) {
            return YES;
        }
        return NO;
    }];
    [filter subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}
#pragma mark 根据内容判断按钮是否可以点击
- (void)btnEnabled{
    // 组合
    //  <#(nonnull id<NSFastEnumeration>)#> 这个协议就是数组 组合那些信号
    // reduce 聚合
    // block参数: 跟组合的信号有关.一一对应
    RACSignal *com = [RACSignal combineLatest:@[_userName.rac_textSignal,_pass.rac_textSignal] reduce:^id(NSString * name, NSString *pwd){
        // block: 只要源信号发送内容就会调用 ,组合成一个新的值
        NSLog(@"%@    %@",name,pwd);
        // 聚合的值就是组合信号的内容
        return @(name.length && pwd.length);
    }];
    //    [com subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    
    RAC(_loginBtn,enabled) = com;
}
- (void)then{
    RACSignal *a = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送上部分请求");
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *b = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送下部分请求");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // 忽略到第一个信号的所有值
    [[a then:^RACSignal * _Nonnull{
        // 返回信号需要组合的信号
        return b;
        
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"ddddddd   %@",x);
    }];
}
- (void)concat{
    RACSignal *a = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送上部分请求");
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *b = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"发送下部分请求");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // concat按顺序去链接
    // 注意: 第一个信号必须调用sendCompleted
    // 创建组合信号
    RACSignal *concat = [a concat:b];
    
    // 订阅组合信号
    [concat subscribeNext:^(id  _Nullable x) {
        // 既能拿到a信号值,又可以d拿到的值
        NSLog(@"sss  %@",x);
    }];
}
// 映射  flattenMap:用于信号中的信号
- (void)map{
    RACSubject *sub = [RACSubject subject];

    // 绑定信号
    RACSignal *bind = [sub map:^id _Nullable(id  _Nullable value) {
        //
        // 返回的类型就是你需要映射的值
        
        //        return @"000";
        return value;
    }];
    
    [bind subscribeNext:^(id  _Nullable x) {
        NSLog(@"aaa %@",x);
    }];
    
    [sub sendNext:@"111"];
    [sub sendNext:@"1112222"];
    
    
}
// 开发中一般不用 RAC底层
- (void)bind{
    RACSubject *sub = [RACSubject subject];
    // 绑定信号
    RACSignal *bind = [sub bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *( id value, BOOL *stop){
            // 只要源信号发送数据,就会调用block
            // block作用:处理源信号内容
            // value 源信号内容
            NSLog(@"ffff %@",value);
            // 返回信号,不能是nil,返回空信号[RACSignal empty]
            return [RACReturnSignal return:value];
        };
    }];
    
    [bind subscribeNext:^(id  _Nullable x) {
        NSLog(@"aaaa %@",x);
    }];
    
    [sub sendNext:@"111"];
}
- (void)command{
    //   RACCommand 处理事件 ,不能返回一个空的信号
    RACCommand *comm = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //        input :执行命令传入的参数
        NSLog(@"input %@",input);
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            
            [subscriber sendNext:@"执行命令产生的数据"];
            return nil;
        }];
    }];
    // 如何拿到执行命令中产生的数据
    //    [[comm execute:@"1"] subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"%@",x);
    //    }];
    //
    // executionSignals: 信号源,信号中的信号,发送的数据就是信号
    //    [comm.executionSignals subscribeNext:^(RACSignal * signle) {
    //        NSLog(@"%@",signle);
    //        [signle subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"%@",x);
    //        }];
    //    }];
    //switchToLatest 获取最新发送的信号,只能用于信号中的信号
    //    [comm.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
    //
    //    }];
    
    [comm execute:@"1"];
}
- (void)connection{
    // 不管订阅多少次信号,就只会请求一次
    // 1.创建信号  2.把信号转换成l链接类信号  3.订阅链接类的信号  4.链接
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"*******");
        [subscriber sendNext:@"热门模块数据"];
        return nil;
    }];
    RACMulticastConnection *connection = [signal publish];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"1  %@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"2  %@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"3  %@",x);
    }];
    
    [connection connect];
}
#pragma mark 常见的宏
- (void)hong{
    // 用来给某个对象的某个属性绑定信号,只要产生信号内容,就会把内容给属性赋值
     RAC(_btn,titleLabel.text) = _textField.rac_textSignal;
    // 只要对象的属性一改变就会产生信号
        RACObserve(self.view, frame);
       // 包装元祖
        RACTuple *tuple = RACTuplePack(@(1),@(2),@"0");
        NSLog(@"%@",tuple[0]);
        RACTuple *tuple1 = RACTuplePack(@(1), @(2));
        RACTupleUnpack(NSNumber *number1, NSNumber *number2) = tuple1;
        NSLog(@"RACTupleUnpack -- %@ -- %@", number1, number2);
}
- (void)liftSelector{
    // 请求一个热销
    RACSignal *hot = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 请求数据 AFN
        NSLog(@"请求数据");
        [subscriber sendNext:@"热销模块数据"];
        return nil;
    }];
    
    // 请求一个最新
    RACSignal *new = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 请求数据 AFN
        NSLog(@"请求数据");
        [subscriber sendNext:@"最新模块数据"];
        return nil;
    }];
    
    
    // 当一个页面有多次请求的时候
    // 数组: 存放信号
    // 当数组中的所有信号都发送数据的时候,才会执行sel
    // 方法的参数: 要和数组的信号一一对应,是每一个信号发送的数据
    [self rac_liftSelector:@selector(showUIWithHotNew:new:) withSignalsFromArray:@[hot,new]];
}
- (void)showUIWithHotNew:(NSString *)hot new:(NSString *)new{
    // 拿到请求数据
    NSLog(@"展示页面了hot: %@  new: %@",hot,new);
}
#pragma mark rac_textSignal
- (void)text{
    [_textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
}
#pragma mark 通知
- (void)notification{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"弹出键盘");
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _redview.frame = CGRectMake(20, 50, 100, 100);
}
#pragma mark KVO
- (void)kvo{
    // 需要在ReactiveObjC中 导入头文件 #import "NSObject+RACKVOWrapper.h"
//        [_redview rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
//
//        }];
    
    [[_redview rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}
#pragma mark 代理
- (void)delegate2{
    // 监听某个对象有没有调用某方法
    [[_redview rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"控制器知道按钮被点击了");
    }];
}
#pragma mark RACSubject
- (void)delegate1{
    [_redview.btnClickSingal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}
#pragma mark 集合
- (void)dict{
    NSDictionary *dic = @{@"key":@"1",@"num":@"10"};
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解析元祖
        // 宏里面的参数传: 将需要解析出来的变量名
        // = 放需要解析的元祖
        RACTupleUnpack(NSString *key,NSString *value) = x;
         NSLog(@"%@  %@",key,value);
        
    }];
    
    NSArray *dicArr = @[@{@"key":@"1",@"num":@"10"},@{@"key":@"2",@"num":@"30"}];
   
    // 高级用法
    // 会把集合中所有的元素映射成一个新的对象
    NSArray *arr = [[dicArr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        //value 集合中元素
        // 返回对象就是映射的值
        return [FlagModel flagWithDict:value];
    }] array];
    NSLog(@"%@",arr);
}
#pragma mark RACSequence 集合
- (void)arr{
    NSArray *arr = @[@"2",@"3",@1];
    // RAC集合
    RACSequence *sequence = arr.rac_sequence;
    
    // 把集合转成信号
    RACSignal *sin = sequence.signal;
    
    // 订阅集合信号,内部会自动遍历所有的元素发出来
    [sin subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    
//    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@",x);
//    }];
}
#pragma mark 元祖 RACTuple
- (void)tuple{
    // 元祖类
    RACTuple *tuple = [RACTuple tupleWithObjects:@[@"2",@"3",@"3"], @(1), nil];
    NSString *str = tuple[1];
    NSLog(@"%@",str);
}
#pragma mark RACSubject
- (void)test2{
    // 1.创建信号(冷信号)
    RACSubject *sub = [RACSubject subject];
    
    // 2.订阅信号 (热信号)
    [sub subscribeNext:^(id  _Nullable x) {
        // x: 信号发送的内容
        NSLog(@"信号发送的内容 %@",x);
        // 底层实现: 遍历所有的订阅者,调用nextBlock
    }];
    
    // 3.发送数据
    [sub sendNext:@"1"];
}
- (void)test1{
    RACSignal *sing = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self->_subscriber = subscriber;
        
        [subscriber sendNext:@"1"];
        return [RACDisposable disposableWithBlock:^{
            // 只要信号取消订阅就会来这
            // 清空资源
            NSLog(@"取消订阅");
        }];
    }];
    
    
    RACDisposable *dis = [sing subscribeNext:^(id  _Nullable x) {
        
    }];
    // 只要订阅者在,就不会自动取消信号订阅
    
    // 手动取消订阅
    [dis dispose];
}
- (void)test{
    // 函数式编程思想: 方法中传block
    // 创建信号(冷信号)
    RACSignal *sing = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 3.发送信号 (数据)
        [subscriber sendNext:@"1"];
        return nil;
    }];
    
    // 订阅信号 (热信号)
    [sing subscribeNext:^(id  _Nullable x) {
        // x: 信号发送的内容
    }];
}
@end
