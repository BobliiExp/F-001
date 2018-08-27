//
//  PYVCTabMonster.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabMonster.h"
#import "PYVCHistory.h"

@interface PYVCTabMonster ()<UITableViewDelegate, UITableViewDataSource>{
    BOOL isOpen;    ///< 是否展开
}

@property (nonatomic, weak) UITableView *tableView; ///<
@property (nonatomic, strong) UIButton *btn; ///< 折叠按钮

@end

@implementation PYVCTabMonster

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tabBarItem.title;
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    CGFloat height = kScreenHeight - self.tabBarController.tabBar.frame.size.height;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height - 40, kScreenWidth, 40) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView delegate - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return isOpen ? (self.mArrData.count > 3 ? 3 : self.mArrData.count) : 0;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.backgroundColor = [UIColor colorWithARGBString:@"#eeeeee"];
    }
    
    cell.textLabel.text = @"历史记录";
    //    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor whiteColor] : [UIColor colorWithARGBString:@"#eeeeee"];
    //    [cell setupData:self.mArrData[indexPath.row]];
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
    
    if (!self.btn) {
        self.btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 24 - 12.f, 8.f, 24, 24)];
        [self.btn setImage:[UIImage imageNamed:@"ic_down_arrow"] forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(btnOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [view addSubview:self.btn];
    
    CALayer *line = [[CALayer alloc] init];
    line.backgroundColor = kColor_Content.CGColor;
    line.frame = CGRectMake(0, 40, kScreenWidth, 1);
    [view.layer addSublayer:line];
    
    [view addSubview:labTabView];
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PYVCHistory *vc = [[PYVCHistory alloc] init];
    vc.type = PYHistoryTypeLottery;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapViewOnClicked:(UITapGestureRecognizer *)tap {
    PYVCHistory *vc = [[PYVCHistory alloc] init];
    vc.type = PYHistoryTypeLottery;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnOnClicked:(UIButton *)btn {
    isOpen = !isOpen;
    [btn setImage:[UIImage imageNamed:isOpen ? @"ic_up_arrow" : @"ic_down_arrow"] forState:UIControlStateNormal];
    [self.tableView reloadData];
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
