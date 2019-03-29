//
//  LoginViewModel.h
//  MVVM
//
//  Created by zlhj on 2019/3/29.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface LoginViewModel : NSObject

// 保存登录界面的账号与密码
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * pwd;

// 处理登录按钮是否允许点击
@property (nonatomic,strong,readonly) RACSignal * loginEnableSignal;

// 登录按钮的命令
@property (nonatomic,strong,readonly) RACCommand * loginComm;
@end

NS_ASSUME_NONNULL_END
