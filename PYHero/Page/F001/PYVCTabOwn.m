//
//  PYVCTabOwn.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabOwn.h"
#import "PYVCOwnSetting.h"
#import "PYVCHistory.h"
#import "NSDate+PYHero.h"
#import "PYVAlertStep.h"

@interface PYVCTabOwn ()<UITableViewDelegate, UITableViewDataSource>{
    
}

@property (nonatomic, weak) UITableView *tableView; ///<
@property (nonatomic, strong) NSMutableArray *mArrUserInfo;    ///< 用户信息

@end

@implementation PYVCTabOwn


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.tabBarItem.title;
    
    [self setup];
    [self setupData];
    
    
}

- (void)setup {
    CGFloat bottomNav = [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, bottomNav, kScreenWidth, kScreenHeight - bottomNav - self.tabBarController.tabBar.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = kColor_Background;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}

- (void)setupData {
    self.mArrUserInfo = [PYUserManage py_getUserInfo].mutableCopy;
    self.mArrData = @[KLocalizable(@"voice")/*,@"摇一摇"*/,KLocalizable(@"lottery")/*,@"捉妖"*/].mutableCopy;
    
    [self.tableView reloadData];
}

- (NSDate *)zeroOfDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[NSDate date]];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}

#pragma mark - tabelView Delegate dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = kFont_Title;
        cell.textLabel.textColor = kColor_Title;
    }
    
    cell.textLabel.text = self.mArrData[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = self.tableView.backgroundColor;
    
    UIView *vBg = [[UIView alloc] init];
    vBg.backgroundColor = [UIColor whiteColor];
    [view addSubview:vBg];
    
    [vBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(12.f);
        make.left.right.equalTo(view);
        make.bottom.equalTo(view).offset(-12.f);
    }];
    
    CGFloat width = 80;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    imgV.image = self.mArrUserInfo.firstObject;
    [vBg addSubview:imgV];
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(width));
        make.top.mas_equalTo(view).offset(30);
        make.centerX.equalTo(view);
    }];
    imgV.layer.cornerRadius = width/2.f;
    imgV.layer.masksToBounds = YES;
    
    imgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labOnClicked:)];
    [imgV addGestureRecognizer:tapImg];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12.f, imgV.mj_y+imgV.mj_h + 20.f, kScreenWidth - 12.f*2, 20)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = self.mArrUserInfo.lastObject;
    lab.font = kFont_Title;
    lab.textColor = kColor_Title;
    [vBg addSubview:lab];
    
    lab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labOnClicked:)];
    [lab addGestureRecognizer:tap];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgV.mas_bottom).offset(12.f);
        make.left.equalTo(view).offset(12.f);
        make.right.equalTo(view).offset(-12.f);
        make.height.equalTo(@20);
    }];
    
    // 我的积分
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = kColor_Background;
    [view addSubview:vLine];
    
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(24.f);
        make.left.right.equalTo(view);
        make.height.equalTo(@12);
    }];
    
    UILabel *labPoint = [[UILabel alloc] init];
    labPoint.font = lab.font;
    labPoint.textColor = lab.textColor;
    [vBg addSubview:labPoint];
    
    PYModelAttr *model = [[PYModelAttr alloc] init];
    model.arrText = @[KLocalizable(@"currentPoints"), [PYUserManage py_getPoint], @"分"];
    model.arrFgColor = @[kColor_Title, kColor_Select, kColor_Title];
    [labPoint setAttributedTextWithModel:model];
    
    [labPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vLine.mas_bottom);
        make.left.equalTo(view).offset(12);
        make.right.equalTo(view).offset(-12);
        make.height.equalTo(@40);
    }];
    
    // 我的步数
    UIView *vLine2 = [[UIView alloc] init];
    vLine2.backgroundColor = kColor_Background;
    [view addSubview:vLine2];
    
    [vLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labPoint.mas_bottom);
        make.left.right.equalTo(view);
        make.height.equalTo(@12);
    }];
    
    UILabel *labStep = [[UILabel alloc] init];
    labStep.font = lab.font;
    labStep.textColor = lab.textColor;
    labStep.userInteractionEnabled = YES;
    labStep.text = KLocalizable(@"stepRedemption");
    [vBg addSubview:labStep];
    
    [labStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view).offset(-12);
        make.left.equalTo(view).offset(12);
        make.right.equalTo(view).offset(-12);
        make.height.equalTo(@40);
    }];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewOnClicked:)];
    [labStep addGestureRecognizer:tap2];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 154.f + 24.f + 40.f*2 + 12.f*2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PYVCHistory *vc = [[PYVCHistory alloc] init];
    vc.type = indexPath.row;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)labOnClicked:(UITapGestureRecognizer *)tap {
    PYVCOwnSetting *vc = [[PYVCOwnSetting alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) weakSelf = self;
    vc.block = ^{
        weakSelf.mArrUserInfo = [PYUserManage py_getUserInfo].mutableCopy;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapViewOnClicked:(UITapGestureRecognizer *)tap {
    if (![NSDate isSameDay:(NSDate *)[PYUserManage py_getObjectWithKey:@"ConvertStep"]]) { // 未兑换
        if ([NSDate validateWithStartTime:@"18:00" expireTime:@"20:00"]) { // 在兑换时间段内
            [AFFAlertView alertWithView:[[PYVAlertStep alloc] initWithType:0] block:^(NSInteger index, BOOL isCancel) {
                if (index) {
                    [PYUserManage py_saveObject:[NSDate date] key:@"ConvertStep"];
                    [self.tableView reloadData];
                }
            }];
        }else { // 未在兑换时间内
            [AFFAlertView alertWithView:[[PYVAlertStep alloc] initWithType:1] block:^(NSInteger index, BOOL isCancel) {}];
        }
    }else { // 已兑换
        [AFFAlertView alertWithView:[[PYVAlertStep alloc] initWithType:2] block:^(NSInteger index, BOOL isCancel) {}];
    }
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
