//
//  PYVCTabLottery.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabLottery.h"
#import "PYVLottery.h"
#import "PYCellLottery.h"
#import "PYVCHistory.h"
#import "PYImgVLottery.h"
#import "PYVAlertLottery.h"

@interface PYVCTabLottery ()<UITableViewDelegate, UITableViewDataSource>{
    CGFloat _currentTimes;
    NSInteger _currentIndex;
    NSInteger _lastIndex;
    BOOL _isFirst;
    BOOL _isPlay;  ///< 是否开始游戏
    BOOL isOpen;    ///< 是否展开
    NSInteger _count; ///< 已经游戏的次数
}

@property (nonatomic, weak) UITableView *tableView; ///<
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *mArrTime;    ///< 时间数组
@property (nonatomic, strong) NSMutableDictionary *mDicPoint;    ///< 积分字典
@property (nonatomic, weak) PYVLottery *vLottery; ///< 转一转视图
@property (nonatomic, strong) UIButton *btn; ///< 折叠按钮

@end

@implementation PYVCTabLottery

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tabBarItem.title;
    // Do any additional setup after loading the view.
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeUI)];
    self.displayLink.paused = YES;
    self.displayLink.frameInterval =1;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setupUI {
    PYVLottery *vLottery = [[PYVLottery alloc] init];
    vLottery.center = CGPointMake(kScreenWidth/2.f, kScreenHeight/2.f);
    [self.view addSubview:vLottery];
    self.vLottery = vLottery;
    
    [vLottery.btnAction addTarget:self action:@selector(btnActionOnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *arrImg = @[@"seven",@"mango",@"melon",@"banana",@"orange"];
    CGFloat width = 35.f;
    CGFloat height = 49.f;
    CGFloat space = 20.f;
    CGFloat delatY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(space, delatY + 25.f, kScreenWidth - 2*space, height+20.f)];
    view.backgroundColor = kColor_Select;
    [self.view addSubview:view];
    
    CGFloat y = 10.f;
    if (self.view.mj_w <= 320) {
        view.mj_y = delatY+10;
        view.mj_h = height + 10;
        y = 5.f;
    }
    view.layer.cornerRadius = view.mj_h/2.f;
    view.layer.masksToBounds = YES;
    
    space = 12.f;
    CGFloat margin = (view.mj_w - 4*space - width*arrImg.count)/2;
    
    for (NSInteger i = 0; i < arrImg.count; i++) {
        PYImgVLottery *imgV = [[PYImgVLottery alloc] initWithFrame:CGRectMake(margin + (width+space)*i, y, width, height) imgName:arrImg[i] point:5-i];
        [view addSubview:imgV];
    }
    
    height = kScreenHeight - self.tabBarController.tabBar.frame.size.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height - 40, kScreenWidth, 40) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
}

- (void)setupData {
    _isFirst = YES;
    _currentIndex = -1;
    
    NSArray *arrImg = @[@"sevens",@"mangos",@"melons",@"bananas",@"oranges",@"seven",@"mango",@"melon",@"banana",@"orange"];
    self.mDicPoint = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i<self.vLottery.arrImgName.count; i++) {
        NSString *str = self.vLottery.arrImgName[i];
        if ([arrImg containsObject:str]) {
            [self.mDicPoint setObject:[self getNumberWithImageName:str] forKey:[NSString stringWithFormat:@"%ld",i]];
        }
    }
    
    self.mArrData = [PYUserManage py_getLotteryData].mutableCopy;
    [self.tableView reloadData];
}

- (NSString *)getNumberWithImageName:(NSString *)imgName {
    NSString *number = @"0";
    if ([imgName isEqualToString:@"seven"]) {
        number = @"5";
    }else if ([imgName isEqualToString:@"mango"]) {
        number = @"4";
    }else if ([imgName isEqualToString:@"melon"]) {
        number = @"3";
    }else if ([imgName isEqualToString:@"banana"]) {
        number = @"2";
    }else if ([imgName isEqualToString:@"orange"]) {
        number = @"1";
    }else if ([imgName isEqualToString:@"sevens"]) {
        number = @"10";
    }else if ([imgName isEqualToString:@"mangos"]) {
        number = @"8";
    }else if ([imgName isEqualToString:@"melons"]) {
        number = @"6";
    }else if ([imgName isEqualToString:@"bananas"]) {
        number = @"4";
    }else if ([imgName isEqualToString:@"oranges"]) {
        number = @"2";
    }
    
    return number;
}

- (void)btnActionOnClicked:(UIButton *)btn {
    NSNumber *count = (NSNumber *)[PYUserManage py_getObjectWithKey:@"LotteryCount"];
    _count = count.integerValue;
    
    if (![NSDate isSameDay:(NSDate *)[PYUserManage py_getObjectWithKey:@"LotteryFirstTime"]]) {
        [PYUserManage py_saveObject:[NSDate date] key:@"LotteryFirstTime"];
        _count = 5;
        [PYUserManage py_saveObject:[NSNumber numberWithInteger:_count] key:@"LotteryCount"];
    }
    
    if (_count) {
        _count--;
        [PYUserManage py_saveObject:[NSNumber numberWithInteger:_count] key:@"LotteryCount"];
        
        NSMutableArray *mArrUp = [NSMutableArray array];
        NSMutableArray *mArrDown = [NSMutableArray array];
        CGFloat numberUp = 2.6;
        CGFloat numberDown = 0.2;
        for (NSInteger i = 0; i < 12; i++) {
            numberUp -= 0.2;
            numberDown += 0.2;
            [mArrUp addObject:@(numberUp)];
            [mArrDown addObject:@(numberDown)];
        }
        
        NSMutableArray *sameSpeedArr =[NSMutableArray array];
        
        NSInteger random = arc4random()%50;
        for (int i = 0; i<(12*7+random); i++) {
            [sameSpeedArr addObject:@(0.1)];
        }
        
        self.mArrTime = [NSMutableArray array];
        [self.mArrTime addObjectsFromArray:mArrUp];
        [self.mArrTime addObjectsFromArray:sameSpeedArr];
        [self.mArrTime addObjectsFromArray:mArrDown];
        
        btn.enabled = NO;
        self.displayLink.paused = NO;
        _lastIndex = 100;
        
        if (_isFirst) {
            _isFirst = NO;
        }else {
            _currentIndex--;
        }
        
        if (_currentIndex > 888888) {
            _currentIndex = _currentIndex%(self.vLottery.mArrImg.count);
        }
        _isPlay = YES;
    }else {
        [AFFAlertView alertWithTitle:@"温馨提示" content:@"今日游戏次数已经用光，请明天再来吧！" btnTitle:@[@"确定"] block:^(NSInteger index, BOOL isCancel) {
            [AFFAlertView dismiss];
        }];
    }
}

- (void)changeUI {
    if (self.mArrTime.count) {
        _currentTimes =_currentTimes+0.1;
        CGFloat delayInSeconds = [[self.mArrTime firstObject] doubleValue];
        NSString *currentTime = [NSString stringWithFormat:@"%.2f",_currentTimes];
        NSString *delaySecond = [NSString stringWithFormat:@"%.2f",delayInSeconds];
        
        if ([currentTime isEqualToString:delaySecond]) {
            _currentTimes = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imgV = [self.vLottery.mArrImg objectAtIndex:(++_currentIndex)%(self.vLottery.mArrImg.count)];
                imgV.backgroundColor = [UIColor whiteColor];
                
                if (_lastIndex < 1000) {
                    UIImageView *imgV = [self.vLottery.mArrImg objectAtIndex:_lastIndex%(self.vLottery.mArrImg.count)];
                    imgV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
                }
                _lastIndex = _currentIndex;
            });
            
            [self.mArrTime removeObjectAtIndex:0];
        }
    }else {
        self.vLottery.btnAction.enabled = YES;
        self.displayLink.paused = YES;
        
        if (_isPlay) {
            _isPlay = NO;
            
            NSInteger index = _currentIndex%(self.vLottery.mArrImg.count);
            NSString *point = [self.mDicPoint objectForKey:[NSString stringWithFormat:@"%ld",index]];
            
            if (!point || [point isKindOfClass:[NSNull class]]) {
                point = @"0";
            }
            PYModelAttr *model = [[PYModelAttr alloc] init];
            model.arrText = @[@"当前可用次数：", [NSString stringWithFormat:@"%ld",_count]];
            model.arrFgColor = @[kColor_Title, KColorTheme];
            [self.vLottery.labCount setAttributedTextWithModel:model];
            
            NSString *lastPoint = [PYUserManage py_getPoint];
            NSString *currentPoint = [NSString stringWithFormat:@"%ld",(lastPoint.integerValue + point.integerValue)];
            [PYUserManage py_savePoint:currentPoint];
            
            model = [[PYModelAttr alloc] init];
            model.arrText = @[@"当前积分：", currentPoint];
            model.arrFgColor = @[kColor_Title, KColorTheme];
            
            if (point.integerValue > 0) { // 获得积分
                [PYUserManage py_saveLotteryData:@[point,self.vLottery.arrImgName[index]]];
                
                self.mArrData = [PYUserManage py_getLotteryData].mutableCopy;
                [self.tableView reloadData];
                
                PYVAlertLottery *alert = [[PYVAlertLottery alloc] initWithImgName:self.vLottery.arrImgName[index] point:point];
                [AFFAlertView alertWithView:alert block:^(NSInteger index, BOOL isCancel) {
                    
                }];
            }else {
                PYVAlertLottery *alert = [[PYVAlertLottery alloc] initWithImgName:@"ic_error_empty_net1" point:point];
                [AFFAlertView alertWithView:alert block:^(NSInteger index, BOOL isCancel) {
                    
                }];
            }
        }
    }
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
        cell.textLabel.font = kFont_Title;
        cell.textLabel.textColor = kColor_Title;
        cell.backgroundColor = kColor_Background;
    }
    
    cell.textLabel.text = @"历史记录";
    //    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor whiteColor] : kColor_Background;
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
