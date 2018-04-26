//
//  FourViewController.m
//  RAC深入
//
//  Created by rjb on 2018/4/26.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "FourViewController.h"

@interface FourViewController ()
@property (nonatomic, strong) UITextField *nameTextFiled;
@property (nonatomic, strong) UITextField *pwdTextFiled;
@property (nonatomic, strong) UIButton    *loginButton;
@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.nameTextFiled];
    [self.view addSubview:self.pwdTextFiled];
    [self.view addSubview:self.loginButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.nameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [self.pwdTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextFiled.mas_bottom);
        make.size.equalTo(self.nameTextFiled);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTextFiled.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    
    //将多个信号绑定
    [[RACSignal combineLatest:@[self.nameTextFiled.rac_textSignal,self.pwdTextFiled.rac_textSignal] ]subscribeNext:^(RACTuple * _Nullable x) {
        NSString *name= x.first;
        NSString *pwd = x.second;
        NSLog(@"这是name:%@,这是pwd:%@",name,pwd);
    }];
    
    
    //reduce 合并参数信号的数据进行汇总计算使用
    [[RACSignal combineLatest:@[self.nameTextFiled.rac_textSignal,self.pwdTextFiled.rac_textSignal] reduce:^id _Nonnull(NSString *name,NSString *pwd){
        /*
         对数据汇总计算
         */
        return @(name.length > 0 && pwd.length >0);
    }]subscribeNext:^(id  _Nullable x) {
        /*
         根据汇总的数据的杰伦
         */
        if(![x boolValue]){
            [self.loginButton setTitle:@"不能登录" forState:UIControlStateNormal];
        } else {
            [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
        }
    }];
}

- (UITextField *)nameTextFiled {
    if(!_nameTextFiled){
        _nameTextFiled = [[UITextField alloc]init];
        _nameTextFiled.backgroundColor = [UIColor greenColor];
    }
    return _nameTextFiled;
}

- (UITextField *)pwdTextFiled {
    if(!_pwdTextFiled){
        _pwdTextFiled = [[UITextField alloc]init];
        _pwdTextFiled.backgroundColor = [UIColor redColor];
    }
    return _pwdTextFiled;
}

- (UIButton *)loginButton {
    if(!_loginButton){
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"不能登录" forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor purpleColor];
    }
    return _loginButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
