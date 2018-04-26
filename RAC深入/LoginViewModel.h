//
//  LoginViewModel.h
//  RAC深入
//
//  Created by rjb on 2018/4/26.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface LoginViewModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pwd;

@property (nonatomic, strong) RACSignal *loginEnableSignal;
@property (nonatomic, strong) RACCommand *loginCommend;//从视图控制器过来的命令,

@end
