//
//  RequestViewModel.h
//  MVVM
//
//  Created by zlhj on 2019/3/29.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestViewModel : NSObject
@property (nonatomic,strong,readonly) RACCommand * loginComm;
@end

