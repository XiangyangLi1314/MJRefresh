//
//  ViewController.m
//  MJRefresh
//
//  Created by lixiangyang on 16/1/21.
//  Copyright © 2016年 lixiangyang. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "UIView+MJExtension.h"

#import "MJChiBaoZiHeader.h"


static const CGFloat MJDuration = 2.0;
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

@interface ViewController ()


@property(strong,nonatomic) NSMutableArray  *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    [tab registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self example18];

}

//默认
- (void)example01 {
    
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    tab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [tab.mj_header beginRefreshing];
    
}
//动画刷新
- (void)example02 {
    tab.mj_header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [tab.mj_header beginRefreshing];


}
//上拉加载数据
- (void)example12 {
    [self example01];
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    tab.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)example18 {
    
    [self example01];
    
    tab.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    tab.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    tab.mj_footer.ignoredScrollViewContentInsetBottom = 50;
}





- (void)loadMoreData {
    // 1.添加假数据
    for (int i = 0; i<2; i++) {
        [self.data insertObject:MJRandomData atIndex:0];
        
    }
    
    // 刷新表格
    [tab reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [tab.mj_footer endRefreshing];

}

- (void)loadNewData
{
    // 1.添加假数据
    for (int i = 0; i<2; i++) {
        [self.data insertObject:MJRandomData atIndex:0];
    }
    // 刷新表格
    [tab reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [tab.mj_header endRefreshing];
   
}


- (NSMutableArray *)data {
    if (!_data) {
        self.data = [NSMutableArray array];
        for (int i = 0; i<3; i++) {
            [self.data addObject:MJRandomData];
        }
    }
    return _data;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:indentifier];
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
