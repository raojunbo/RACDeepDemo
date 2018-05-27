//
//  RACSubjectViewController.m
//  RAC深入
//
//  Created by rjb on 2018/5/26.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "RACSubjectViewController.h"
#import "ReactiveObjC.h"

@interface RACSubjectViewController ()

@end

@implementation RACSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    /*
         RACSubject 继承RACSignal,实现RACSubscriber协议
     */
    
    /*
     1.创建信号
     */
    RACSubject *subject = [RACSubject subject];
    
    /*
     2.订阅信号
     创建subscribe 添加到 subscribers
     */
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"收到信号");
    }];
    
    /*3.发送数据
    遍历subscribers，调用sublcriber的nextBlock。
     */
    [subject sendNext:@"你好"];

    /*
     思路:在subscibeNext时候，创建subscibe添加到subsribers
     在发送数据时，遍历数组执行保存的nextblock
     哈，哈，就是这么理解的
     */
    
    /*
     引申：在subscribeNext订阅时，在底层代码都会，创建一个订阅者(subscriber)，订阅者里都存着要要执行的代码block;
     在sendNext时，会取到subscriber执行这个block
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
