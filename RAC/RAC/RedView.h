//
//  RedView.h
//  RAC
//
//  Created by zlhj on 2019/3/26.
//  Copyright © 2019 zlhj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globe.h"
NS_ASSUME_NONNULL_BEGIN

@interface RedView : UIView
@property (nonatomic,strong) RACSubject * btnClickSingal;
@end

NS_ASSUME_NONNULL_END
