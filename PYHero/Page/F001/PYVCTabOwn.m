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
#import <CoreMotion/CoreMotion.h>
#import "NSDate+PYHero.h"
#import "PYVAlertStep.h"

@interface PYVCTabOwn ()<UITableViewDelegate, UITableViewDataSource>{
    NSNumber *step;
}

@property (nonatomic, weak) UITableView *tableView; ///<
@property (nonatomic, strong) NSMutableArray *mArrUserInfo;    ///< 用户信息
@property (nonatomic, strong) CMPedometer *pedometer;

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
    tableView.backgroundColor = [UIColor colorWithARGBString:@"#eeeeee"];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}

- (void)setupData {
    self.mArrUserInfo = [PYUserManage py_getUserInfo].mutableCopy;
    self.mArrData = @[@"语音"/*,@"摇一摇"*/,@"转一转"/*,@"捉妖"*/].mutableCopy;
    step = @0;
    [self py_getUserStep];
}

- (void)py_getUserStep {
    self.pedometer = [[CMPedometer alloc]init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *startDate = [self zeroOfDate];
    NSString *time = [NSDate date2String:startDate];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:startDate options:0];
    NSString *time2 = [NSDate date2String:endDate];
    NSLog(@"%@--%@",time,time2);
    
    //判断记步功能
    if ([CMPedometer isStepCountingAvailable]) {
        [self.pedometer queryPedometerDataFromDate:endDate toDate:startDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@">>>error====%@",error);
                    [self.tableView reloadData];
                }else {
                    step = pedometerData.numberOfSteps;
                    [self.tableView reloadData];
                    NSLog(@"步数====%@",pedometerData.numberOfSteps);
                    NSLog(@"距离====%@",pedometerData.distance);
                }
            });
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSLog(@"记步功能不可用");
        });
    }
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
    lab.font = kFont_XL;
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
    vLine.backgroundColor = [UIColor colorWithARGBString:@"#eeeeee"];
    [view addSubview:vLine];
    
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab.mas_bottom).offset(24.f);
        make.left.right.equalTo(view);
        make.height.equalTo(@12);
    }];
    
    UILabel *labPoint = [[UILabel alloc] init];
    labPoint.font = lab.font;
    labPoint.textColor = lab.textColor;
    labPoint.text = [NSString stringWithFormat:@"当前用户积分：%@分",[PYUserManage py_getPoint]];
    [vBg addSubview:labPoint];
    
    [labPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vLine.mas_bottom);
        make.left.equalTo(view).offset(12);
        make.right.equalTo(view).offset(-12);
        make.height.equalTo(@40);
    }];
    
    // 我的步数
    UIView *vLine2 = [[UIView alloc] init];
    vLine2.backgroundColor = [UIColor colorWithARGBString:@"#eeeeee"];
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
    labStep.text = [NSString stringWithFormat:@"当前用户步数：%@步",step];
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
    if (![NSDate isSameDay:(NSDate *)[PYUserManage py_getObjectWithKey:@"ConvertStep"]]) {
        [PYUserManage py_saveObject:[NSDate date] key:@"ConvertStep"];
        
        [AFFAlertView alertWithView:[[PYVAlertStep alloc] initWithStep:step.integerValue] block:^(NSInteger index, BOOL isCancel) {
            if (index) {
                [self.tableView reloadData];
            }
        }];
    }else {
        [AFFAlertView alertWithView:[[PYVAlertStep alloc] initWithStep:0] block:^(NSInteger index, BOOL isCancel) {}];
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
