//
//  MVVMViewController.m
//  RAC深入
//
//  Created by rjb on 2018/4/26.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "MVVMViewController.h"
#import "LoginViewModel.h"
@interface MVVMViewController ()
@property (nonatomic, strong) UITextField   *nameText;
@property (nonatomic, strong) UITextField   *pwdText;
@property (nonatomic, strong) UIButton      *button;

@property (nonatomic, strong) LoginViewModel *loginViewModel;

@end

@implementation MVVMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nameText];
    [self.view addSubview:self.pwdText];
    [self.view addSubview:self.button];
    
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.equalTo(self.view);
    }];
    
    [self.pwdText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameText.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.equalTo(self.view);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pwdText.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(200, 40));
        make.centerX.equalTo(self.view);
    }];
    
    /*
     需求
     1.当nameText的值发生变化时，viewModel的值会发生变化
     相当于我下面订阅
     [self.nameText.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
         self.loginViewModel.name = x;
     }];
     2.当loginViewModel里的值，发生变化时，在loginViewModel里通过kvo监听
     创建信号，经过处理（reduce）后返回值会来
     本页面，通过绑定，self.button的enable的属性与，信号的回来的进行绑定。也即监听，viewModel里的信号
     
     3.本页面要发出一个命令,让通过命令，让viewModel里的定义好命令开始执行
     至于为什么要用命令??
     
     */
   
    RAC(self.loginViewModel,name) = self.nameText.rac_textSignal;
    RAC(self.loginViewModel,pwd) = self.pwdText.rac_textSignal;

    RAC(self.button,enabled) = self.loginViewModel.loginEnableSignal;

    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.loginViewModel.loginCommend execute:nil];
    }];
    
}

- (UITextField *)nameText {
    if(!_nameText){
        _nameText = [[UITextField alloc]init];
        _nameText.backgroundColor = [UIColor redColor];
    }
    return _nameText;
}

- (UITextField *)pwdText {
    if(!_pwdText){
        _pwdText = [[UITextField alloc]init];
        _pwdText.backgroundColor = [UIColor greenColor];
    }
    return _pwdText;
}

- (UIButton *)button {
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor purpleColor];
        [_button setTitle:@"title" forState:UIControlStateNormal];
    }
    return _button;
}

- (LoginViewModel *)loginViewModel {
    if(!_loginViewModel){
        _loginViewModel = [[LoginViewModel alloc]init];
    }
    return _loginViewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
