//
//  RACApplicationViewController.m
//  RAC深入
//
//  Created by rjb on 2018/5/26.
//  Copyright © 2018年 rjb. All rights reserved.
//
#import "RACApplicationViewController.h"
#import "ReactiveObjC.h"

@interface CustomView:UIView
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) RACSubject *subject;
@end

@implementation CustomView

- (instancetype)init {
    if(self = [super init]){
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    [self addSubview:self.button];
}

- (UIButton *)button {
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"发送消息" forState:UIControlStateNormal];
        @weakify(self);
        [[_button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.subject sendNext:nil];
        }];
    }
    
    return _button;
}


- (RACSubject *)subject {
    if(!_subject){
        _subject = [RACSubject subject];
    }
    return _subject;
}

@end


/*
 RAC应用
 */
@interface RACApplicationViewController ()
@property (nonatomic, strong)CustomView *customView;
@end

@implementation RACApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.customView];
    [self.customView.subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"点击来了");
    }];
}

- (CustomView *)customView {
    if(!_customView){
        _customView = [[CustomView alloc]init];
        _customView.backgroundColor = [UIColor redColor];
    }
    return _customView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
