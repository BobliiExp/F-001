//
//  PYVCTabMonster.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabMonster.h"

@interface PYVCTabMonster ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView; ///<

@end

@implementation PYVCTabMonster

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tabBarItem.title;
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    CGFloat height = kScreenHeight - self.tabBarController.tabBar.frame.size.height;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height - 40*4, kScreenWidth, 40*4) style:UITableViewStylePlain];
    tableView.backgroundColor = kColor_Content;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrData.count > 3 ? 3 : self.mArrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *labTabView = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 150)/2.f, 0, 150, 40)];
    labTabView.backgroundColor = [UIColor whiteColor];
    labTabView.textAlignment = NSTextAlignmentCenter;
    labTabView.textColor = kColor_Title;
    labTabView.font = [UIFont fontBold:15.f];
    labTabView.text = @"近期历史记录";
    labTabView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewOnClicked:)];
    [labTabView addGestureRecognizer:tap];
    
    [view addSubview:labTabView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tapViewOnClicked:(UITapGestureRecognizer *)tap {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
