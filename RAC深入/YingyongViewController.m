//
//  YingyongViewController.m
//  RAC深入
//
//  Created by rjb on 2018/4/26.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "YingyongViewController.h"

@interface YingyongViewController ()
@property (nonatomic, strong) UISlider      *redSlider;
@property (nonatomic, strong) UISlider      *greenSlider;

@property (nonatomic, strong) UITextField   *redInputTextField;
@property (nonatomic, strong) UITextField   *greenInputTextField;

@property (nonatomic, strong) UIView        *showView;
@end

/*
 1. 高级函数
 map,filter,flatternMap,concat
 
 2. 信号的捆绑
 merge
 combineLatest
 
 3.
 pull 拉 RACSignal
 push 推 RACSequence
 
 
 */

@implementation YingyongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.redSlider];
    [self.view addSubview:self.redInputTextField];
    [self.view addSubview:self.greenSlider];
    [self.view addSubview:self.greenInputTextField];
    [self.view addSubview:self.showView];
    
    [self.redSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(20);
    }];
    
    [self.redInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.redSlider);
        make.left.equalTo(self.redSlider.mas_right).offset(30);
    }];
    
    [self.greenSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 20));
        make.top.mas_equalTo(self.redSlider.mas_bottom).offset(20);
        make.left.mas_equalTo(20);
    }];
    
    [self.greenInputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(self.greenSlider);
        make.left.equalTo(self.redSlider.mas_right).offset(30);
    }];
    
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.mas_equalTo(self.greenInputTextField.mas_bottom);
        make.centerX.mas_equalTo(self.view);
    }];
    
    RACSignal *signalRed = [self bindSlider:self.redSlider textField:self.redInputTextField];
    RACSignal *signalGreen = [self bindSlider:self.greenSlider textField:self.greenInputTextField];
    
    
//    [[RACSignal combineLatest:@[signalRed,signalGreen]]subscribeNext:^(RACTuple * _Nullable x) {
//       //合并之后再处理
//        NSLog(@"%@",x);
//
//    }];
    
    
    //***捆绑分先后
    [[[RACSignal combineLatest:@[signalRed,signalGreen]]map:^id _Nullable(RACTuple * _Nullable value) {
        //合并之前先做处理
        RACTuple *tuple = (RACTuple *) value;
        return [UIColor colorWithRed:[tuple.first floatValue] green:[tuple.second floatValue] blue:1 alpha:1];
        
    }]subscribeNext:^(id  _Nullable x) {
        self.showView.backgroundColor  = x;
    }];
    
    //或者，直接这么写
//    RAC(self.showView,backgroundColor) =  backGroundSignal;
//    [self demoMapSequence];
//    [self demoFilterSequence];
    [self demoFlattenMap];
}


- (void)demoMapSequence {
    NSArray *arr = @[@1,@2];
    //序列
    RACSequence *seq = [arr rac_sequence];
    [seq array];
    //由此可见map的作用是,把里面的所有东西一个一个都做代码块里的相同的事情
    NSLog(@"%@",[[seq map:^id _Nullable(id  _Nullable value) {
        return @([value intValue] * 3);
    }]array]);
}

- (void)demoSubject {
    //可以当做一个信号,也可以发送信号
    RACSubject *subject = [RACSubject subject];
   
    RACSignal *signal = [subject map:^id _Nullable(id  _Nullable value) {
        return value;
    }];
    
    RACSubject *binSignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        //原信号的内容
        value = [NSString stringWithFormat:@"数据处理"];
        return [RACSignal return:value];
    }];
    
}
- (void)demoFilterSequence {
    RACSequence *seq = [@[@1,@2,@3,@4,@5] rac_sequence];
    //过滤,block里是过过滤的条件。
    NSLog(@"%@",[[seq filter:^BOOL(id  _Nullable value) {
        return [value intValue] %2 == 1;
    }]array]);
}

- (void)demoFlattenMap {
    //数组中的数组，信号中的信号
    RACSequence *s1 = [@[@1,@2,@3] rac_sequence];
    RACSequence *s2 = [@[@1,@3,@9] rac_sequence];
    RACSequence *s3 = [[@[s1,s2] rac_sequence] flattenMap:^__kindof RACSequence * _Nullable(id  _Nullable value) {
        return [value filter:^BOOL(id  _Nullable value) {
            return [value integerValue]%3 == 0;
        }];
    }];
    NSLog(@"%@",[s3 array]);
}

- (void)createSignal {
    __block int a = 10;
    RACSignal *s = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        a += 5;
        [subscriber sendNext:@(a)];
        return nil;
    }] replayLast];
    //**副作用的解决
    //replayLast,每次订阅完后，清空。这样a的值就会重新赋值
    
    [s subscribeNext:^(id  _Nullable x) {
        
    }];
}

- (RACSignal *)bindSlider:(UISlider *)slider textField:(UITextField *)textField {
    
    
    RACSignal *signal = [[textField rac_textSignal] take:1];
    
    //实现双向绑定
    RACChannelTerminal *signalSlider = [slider rac_newValueChannelWithNilValue:nil];
    RACChannelTerminal *signalText = [textField rac_newTextChannel];
    
    //给signalText添加订阅者
    [signalText subscribe:signalSlider];
    
    //给slider添加订阅者signalTex
    [[signalSlider map:^id _Nullable(id  _Nullable value) {
        return [NSString stringWithFormat:@"%.02f",[value floatValue]];
    }]subscribe:signalText];
    
    //***merge 捆绑不分先后
    return [[signalText merge:signalSlider]merge:signal];
}

- (UISlider *)redSlider {
    if(!_redSlider){
        _redSlider = [[UISlider alloc]init];
        _redSlider.backgroundColor = [UIColor redColor];
    }
    return _redSlider;
}

- (UITextField *)redInputTextField {
    if(!_redInputTextField){
        _redInputTextField = [[UITextField alloc]init];
        _redInputTextField.backgroundColor = [UIColor redColor];
    }
    return _redInputTextField;
}

- (UISlider *)greenSlider {
    if(!_greenSlider){
        _greenSlider = [[UISlider alloc]init];
        _greenSlider.backgroundColor = [UIColor greenColor];
    }
    return _greenSlider;
}

- (UITextField *)greenInputTextField {
    if(!_greenInputTextField){
        _greenInputTextField = [[UITextField alloc]init];
        _greenInputTextField.backgroundColor = [UIColor greenColor];
    }
    return _greenInputTextField;
}

- (UIView *)showView {
    if(!_showView){
        _showView = [[UIView alloc]init];
        _showView.backgroundColor = [UIColor purpleColor];
    }
    return _showView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
