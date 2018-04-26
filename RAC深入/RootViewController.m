//
//  RootViewController.m
//  RAC深入
//
//  Created by rjb on 2018/4/25.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "RootViewController.h"
#import "Person.h"

/*
 block是预先准备的一段代码，什么时候执行,我们并不知道
 */
@interface RootViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.button];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom);
        make.centerX.equalTo(self.textField);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
   
}

- (void)setEvent {
    /*
     防止循环引用的理解
     @weakify(self);//为了打破
     @strongify(self);//为了让block一直存在
     */
    //testField代理和Kvo事件
    @weakify(self);
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"这是输入实时监听%@",x);
        @strongify(self);
    }];
    
    
    //button的targe事件
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"这是buttonclik%@",x);
    }];
    
    //通知事件
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"这里是通知收到%@",x);
    }];
}

- (void)testSignal {
    /*rac入门写法*/
    //1.创建信号
    RACSignal  *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //3.发送信号，所谓的发送信号，就是subscripber去执行订阅时设置的next的block对象；
        [subscriber sendNext:@"this is rac,rao"];
        return nil;
    }];
    
    //2.订阅信号,创建订阅者，订阅者里保存了nextblock;
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    /*rac牛逼写法*/
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"this is rac,rao"];
        return nil;
    }]subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
}

- (UITextField *)textField {
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor redColor];
    }
    return _textField;
}

- (UIButton *)button {
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"这是button" forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor greenColor];
    }
    return _button;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
