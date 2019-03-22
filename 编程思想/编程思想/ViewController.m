//
//  ViewController.m
//  编程思想
//
//  Created by zlhj on 2019/3/22.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Calculate.h"
#import "NSObject+KVO.h"
#import "Person.h"
#import "Calculate.h"
@interface ViewController ()
@property (nonatomic,strong) Person * p;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}
// 响应式编程思想
- (void)test2{
    // 参数是一个block 有参数带返回值的block
    Calculate *mg = [[Calculate alloc] init];
    int result = [mg calculate:^(int result){
        result += 5;
        return result;
    }].result;
    
    NSLog(@"%d",result);
}
// 响应式编程思想
- (void)test1{
    // KVO底层实现:监听set 方法的实现,重写set 方法不可使用分类方式,因为分类会覆盖原本的set方法,印象原本set方法的逻辑
    Person *p = [[Person alloc] init];
    [p msj_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    _p = p;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",_p.name);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int i = 0; // 此代码只会执行一次,而且static延长了生命周期
    i++;
    _p.name  = [NSString stringWithFormat:@"%d",i];
}
//链式编程思想
- (void)test{
    int result =  [NSObject msj_makeCalculate:^(CalculateManger * make) {
//         [[make add:5] add:5];
        make.add(5).add(5);
    }];
    NSLog(@"%d",result);
}
@end
