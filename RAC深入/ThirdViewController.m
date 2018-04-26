//
//  ThirdViewController.m
//  RAC深入
//
//  Created by rjb on 2018/4/25.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "ThirdViewController.h"

#define NUMBER 10
#define ADD(a,b) (a + b)

//将参数变成基本的字符串
#define STRINGIFY(s) #s

#define CALCILATE(A,B) _CALCILATE(A,B) //转换宏
#define _CALCILATE(A,B) (A##10##B)

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //用来把参数变成基本的字符串
    metamacro_stringify(10);
    
    NSLog(@"%d + %d = %d",NUMBER,NUMBER,ADD(NUMBER, NUMBER));
    
    NSLog(@"%d",CALCILATE(NUMBER, NUMBER));
    
    NSLog(@"%@",metamacro_stringify(20));
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
