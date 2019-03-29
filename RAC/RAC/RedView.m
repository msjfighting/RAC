//
//  RedView.m
//  RAC
//
//  Created by zlhj on 2019/3/26.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import "RedView.h"

@implementation RedView

- (RACSubject *)btnClickSingal{
    if (_btnClickSingal == nil) {
        _btnClickSingal = [RACSubject subject];
    }
    return _btnClickSingal;
}

- (IBAction)btnClick:(id)sender {
   // [self.btnClickSingal sendNext:@"点击"];
    NSLog(@"点击");
    
}


@end
