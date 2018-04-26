//
//  LoginViewModel.m
//  RAC深入
//
//  Created by rjb on 2018/4/26.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel
- (instancetype)init {
    if(self = [super init]){
        [self setUp];
    }
    return self;
}

- (void)setUp {
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, name),RACObserve(self,pwd)] reduce:^id _Nonnull(NSString *name,NSString *pwd){
        return @(self.name.length && self.pwd.length);
    }];
    
   RACSignal *loginSignal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       return nil;
       
       
    }];
//    [loginSignal subscribeNext:^(id  _Nullable x) {
    
//    }];
    
    
   _loginCommend = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                [subscriber sendNext:@"网络请求"];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    
    [[_loginCommend.executing skip:1]subscribeNext:^(NSNumber * _Nullable x) {
            if([x boolValue]){
                NSLog(@"提示等待");
            } else {
                 NSLog(@"移除等待");
            }
        }];
        //2.执行命令
    [_loginCommend.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            NSLog(@"执行命令");
    }];

}

@end
