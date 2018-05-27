//
//  RACSignalViewController.m
//  RAC深入
//
//  Created by rjb on 2018/5/26.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "RACSignalViewController.h"
#import "ReactiveObjC.h"

/*
 block是预先准备的一段代码，什么时候执行,我们并不知道
 */
@interface RACSignalViewController ()
@property (nonatomic, strong) id<RACSubscriber> subscrib;
@end

@implementation RACSignalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    /*RAC最常见的类,RACSignal
     RACSignal信号类
     1.通过RACSignal 创建信号(冷信号)
     2.通过订阅者来订阅信号(热信号:已经执行了didSubscriber代码，只是在这段代码，执不执行next就与我无关了)
     3.发送信号
     (我的总结:这里给人的感觉是，你在我的代码块里执行你的代码块，我在你的代码块里执行我的代码块)
     */
    
    RACSignal *sigal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        /*
         sendNext:(实际是订阅者，执行subcribeNext的block的代码)
         */
        [subscriber sendNext:@"你好"];
        self.subscrib = subscriber;
        return nil;
        //[RACDisposable disposableWithBlock:^{
//            NSLog(@"订阅被取消");
//        }];
    }];
    
    
    /*实际是创建订阅者,并执行上上面创建信号的block（此block时将订阅者作为入参）*/
    RACDisposable *disposable = [sigal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受到消息1");
    }];
    
    RACDisposable *disposable2 = [sigal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受到消息2");
    }];
    /*
     订阅者在被释放时，会自动执行订阅者被取消
     手动取消订阅
     */
//    [disposable dispose];
}

@end
