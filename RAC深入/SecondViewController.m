//
//  SecondViewController.m
//  RAC深入
//
//  Created by rjb on 2018/4/25.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "SecondViewController.h"
#import "Person.h"
#import <ReactiveObjC.h>

@interface SecondViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) Person *person;
@end

@implementation SecondViewController

- (void)dealloc {
    NSLog(@"bye");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
    [self.view addSubview:self.button];
    [self.view addSubview:self.textField];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom);
        make.centerX.equalTo(self.label);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.top.equalTo(self.button.mas_bottom);
        make.centerX.equalTo(self.label);
    }];
   
    __weak typeof(self) weakself = self;
    
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"这是%@",x);
        weakself.label.text = @"你好";
    }];
    
    //kvo,采用rac的宏
    @weakify(self);
    self.person = [[Person alloc]init];
    [RACObserve(self.person, name) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.label.text = x;
    }];
    
    [[self.textField rac_textSignal]subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"这是文本%@",x);
    }];
    
}

- (UILabel *)label {
    if(!_label){
        _label = [[UILabel alloc]init];
        _label.backgroundColor = [UIColor redColor];
    }
    return _label;
}

- (UIButton *)button {
    if(!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor greenColor];
    }
    return _button;
}

- (UITextField *)textField {
    if(!_textField){
        _textField = [[UITextField alloc]init];
        _textField.backgroundColor = [UIColor purpleColor];
    }
    return _textField;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.name = [NSString stringWithFormat:@"rao%u",arc4random_uniform(1000)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
