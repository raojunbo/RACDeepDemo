//
//  RootViewController.m
//  RAC深入
//
//  Created by rjb on 2018/4/25.
//  Copyright © 2018年 rjb. All rights reserved.
//

#import "RootViewController.h"
#import <Masonry.h>

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *dataArray;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = @[@"RACSignalViewController",@"RACSubjectViewController"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ff"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ff"];
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString([self.dataArray objectAtIndex:indexPath.row]);
    NSObject *objc =  [[class alloc]init];
    [self.navigationController pushViewController:objc animated:YES];
}

@end
