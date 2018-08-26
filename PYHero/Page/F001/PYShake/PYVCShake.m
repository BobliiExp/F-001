//
//  PYVCShake.m
//  PYHero
//
//  Created by crow on 2018/8/17.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVCShake.h"
#import "PYVShakeNumber.h"
#import "PYNumber.h"
#import "PYCellShakeNumber.h"
#import "PYVCHistory.h"

@interface PYVCShake ()<UITableViewDelegate, UITableViewDataSource>{
    CGFloat heightCenter; ///<
    BOOL isOpen;
}

@property (nonatomic, weak) UITableView *tableView; ///<
@property (nonatomic, strong) PYVShakeNumber *shakeNumber;    ///< 摇一摇结果
@property (nonatomic, weak) UILabel *labResult; ///< 中奖结果
@property (nonatomic, weak) UIImageView *imgV;      ///< 摇一摇图片
@property (nonatomic, strong) NSArray *arrData;     ///< 随机获取一组彩票，get方法会获取一组随机数据，所以不能乱用
@property (nonatomic, strong) NSArray *arrWin;      ///< 中奖号码
@property (nonatomic, strong) UIButton *btn; ///< 折叠按钮

@end

@implementation PYVCShake


#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = @"";
    if (self.type == PYLotteryTypeLecaGreati) {
        title = @"七乐彩";
    }else if (self.type == PYLotteryTypeSuperLotto) {
        title = @"大乐透";
    }else {
        title = @"双色球";
    }
    
    self.title = [NSString stringWithFormat:@"%@摇一摇",title];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:NO];
}

- (void)setupUI {
    CGFloat delatY = 12.f + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(12.f, delatY, kScreenWidth - 12.f*2, 40)];
    labTitle.textAlignment = NSTextAlignmentCenter;
    labTitle.textColor = kColor_Title;
    labTitle.font = [UIFont fontBold:17.f];
    labTitle.text = @"幸运号码";
    [self.view addSubview:labTitle];
    
    delatY += CGRectGetHeight(labTitle.frame);
    self.arrWin = self.arrData;
    PYVShakeNumber *vNumber = [[PYVShakeNumber alloc] initWithFrame:CGRectMake(0, delatY, kScreenWidth, 50) data:self.arrWin type:self.type];
    [self.view addSubview:vNumber];
    
    delatY += CGRectGetHeight(vNumber.frame);
    CGFloat height = kScreenHeight - PYSafeBottomHeight;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height - 40*5, kScreenWidth, 40*5) style:UITableViewStylePlain];
    tableView.backgroundColor = kColor_Content;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    UILabel *labShake = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMinY(tableView.frame) - 20 - 12 - 20, kScreenWidth - 12.f*2, 20)];
    labShake.textAlignment = NSTextAlignmentCenter;
    labShake.font = kFont_Large;
    labShake.textColor = kColor_Title;
    labShake.text = @"摇一摇试试您的手气";
    [self.view addSubview:labShake];
    
    heightCenter = labShake.mj_y - vNumber.mj_y - vNumber.mj_h;
    
    height = CGRectGetMidY(labShake.frame) - delatY;
    CGFloat widthImg = 100;
    CGFloat heightImg = 100;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - widthImg)/2.f, delatY + (height - heightImg)/2.f - 20.f, widthImg, heightImg)];
    imgV.backgroundColor = [UIColor redColor];
    imgV.image = [UIImage imageNamed:@""];
    [self.view addSubview:imgV];
    self.imgV = imgV;
}

- (void)setupData {
    self.mArrData = [NSMutableArray arrayWithArray:[PYUserManage py_getShakeData:self.type]];
    [self.tableView reloadData];
}

#pragma mark - tableView delegate - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return isOpen ? (self.mArrData.count > 4 ? 4 : self.mArrData.count) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYCellShakeNumber *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PYCellShakeNumber alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor whiteColor] : kColor_Content;
    [cell py_setupData:[self.mArrData objectAtIndex:indexPath.row] type:self.type];
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
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tapViewOnClicked:(UITapGestureRecognizer *)tap {
    PYVCHistory *vc = [[PYVCHistory alloc] init];
    vc.type = PYHistoryTypeShake;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnOnClicked:(UIButton *)btn {
    isOpen = !isOpen;
    [btn setImage:[UIImage imageNamed:isOpen ? @"ic_up_arrow" : @"ic_down_arrow"] forState:UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark share event

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSMutableArray *arr = self.arrData.mutableCopy;
    
    PYWinResultType winType = [PYWinManage py_winResult:self.type winArr:self.arrWin userArr:arr];
    NSString *str = [PYWinManage py_winString:winType];
    if (winType) {
        [arr addObject:str];
        
        [PYUserManage py_saveShakeData:arr type:self.type];
        self.mArrData = [NSMutableArray arrayWithArray:[PYUserManage py_getShakeData:self.type]];
        [self.tableView reloadData];
    }
    
    if (!self.shakeNumber) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, heightCenter)];
        [self.view addSubview:view];
        CGPoint center = view.center;
        center.y = self.imgV.center.y;
        view.center = center;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 20.f, kScreenWidth - 12.f*2, 20)];
        lab.font = [UIFont fontNormal:15.f];
        lab.text = @"摇一摇结果：";
        lab.textColor = kColor_Title;
        [view addSubview:lab];
        
        UILabel *labResult = [[UILabel alloc] initWithFrame:CGRectMake(12.f, view.mj_h - 20 - 10.f, lab.mj_w, 20)];
        labResult.font = [UIFont fontNormal:15.f];
        labResult.textColor = kColor_Title;
        labResult.textAlignment = NSTextAlignmentCenter;
        [view addSubview:labResult];
        self.labResult = labResult;
        
        self.shakeNumber = [[PYVShakeNumber alloc] initWithFrame:CGRectMake(12.f, 0, kScreenWidth-12.f*2, 50) data:@[] type:self.type];
        center = self.shakeNumber.center;
        center.y = view.mj_h/2.f;
        self.shakeNumber.center = center;
        [view addSubview:self.shakeNumber];
        
        self.imgV.hidden = YES;
    }
    
    [self.shakeNumber py_setupData:arr];
    
    self.labResult.textColor = str.length ? [UIColor redColor] : kColor_Title;
    self.labResult.text = str.length ? [NSString stringWithFormat:@"恭喜你，中了%@!",str] : @"很遗憾，没有中奖，再摇一摇试试手气吧";
}

- (NSArray *)arrData {
    if (self.type == PYLotteryTypeLecaGreati) {
        _arrData = [PYNumber py_getLecaGreatiNumbers];
    }else if (self.type == PYLotteryTypeSuperLotto) {
        _arrData = [PYNumber py_getSuperLottoNumbers];
    }else {
        _arrData = [PYNumber py_getUnionLottoNumbers];
    }
    return _arrData;
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
