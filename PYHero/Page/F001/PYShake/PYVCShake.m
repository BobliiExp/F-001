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

@interface PYVCShake ()<UITableViewDelegate, UITableViewDataSource>{
    CGFloat heightCenter; ///<
}

@property (nonatomic, weak) UITableView *tableView; ///<
@property (nonatomic, strong) PYVShakeNumber *shakeNumber;    ///< 摇一摇结果
@property (nonatomic, weak) UILabel *labResult; ///< 中奖结果
@property (nonatomic, weak) UIImageView *imgV;      ///< 摇一摇图片
@property (nonatomic, strong) NSArray *arrData;     ///< 随机获取一组彩票，get方法会获取一组随机数据，所以不能乱用
@property (nonatomic, strong) NSArray *arrWin;      ///< 中奖号码

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
    labTitle.textColor = kColor_Normal;
    labTitle.font = [UIFont fontBold:17.f];
    labTitle.text = @"中奖号码";
    [self.view addSubview:labTitle];
    
    delatY += CGRectGetHeight(labTitle.frame);
    self.arrWin = self.arrData;
    PYVShakeNumber *vNumber = [[PYVShakeNumber alloc] initWithFrame:CGRectMake(0, delatY, kScreenWidth, 50) data:self.arrWin type:self.type];
    [self.view addSubview:vNumber];
    
    delatY += CGRectGetHeight(vNumber.frame);
    CGFloat height = kScreenHeight - PYSafeBottomHeight;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height - 40*4, kScreenWidth, 40*4) style:UITableViewStylePlain];
    tableView.backgroundColor = kColor_Graylight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    UILabel *labTabView = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMinY(tableView.frame) - 40, kScreenWidth - 12.f, 40)];
    labTabView.textAlignment = NSTextAlignmentCenter;
    labTabView.textColor = kColor_Normal;
    labTabView.font = [UIFont fontBold:15.f];
    labTabView.text = @"近期历史记录";
    [self.view addSubview:labTabView];
    
    UILabel *labShake = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMinY(labTabView.frame) - 20 - 12 - 20, kScreenWidth - 12.f*2, 20)];
    labShake.textAlignment = NSTextAlignmentCenter;
    labShake.font = kFont_Large;
    labShake.textColor = kColor_Normal;
    labShake.text = @"摇一摇试试您的手气";
    [self.view addSubview:labShake];
    
    heightCenter = labShake.mj_y - vNumber.mj_y - vNumber.mj_h;
    
    labShake.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labOnClicked:)];
    [labShake addGestureRecognizer:tap];
    
    height = CGRectGetMidY(labShake.frame) - delatY;
    CGFloat widthImg = 100;
    CGFloat heightImg = 100;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - widthImg)/2.f, delatY + (height - heightImg)/2.f - 20.f, widthImg, heightImg)];
    imgV.backgroundColor = [UIColor redColor];
    imgV.image = [UIImage imageNamed:@""];
    [self.view addSubview:imgV];
    self.imgV = imgV;
}

- (void)labOnClicked:(UITapGestureRecognizer *)tap {
    [self motionEnded:nil withEvent:nil];
}

- (void)setupData {
    self.mArrData = [NSMutableArray arrayWithArray:[PYUserManage py_getShakeData:self.type]];
    [self.tableView reloadData];
}

#pragma mark - tableView delegate - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrData.count > 4 ? 4 : self.mArrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYCellShakeNumber *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PYCellShakeNumber alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor whiteColor] : kColor_Graylight;
    [cell py_setupData:[self.mArrData objectAtIndex:indexPath.row] type:self.type];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
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
        lab.textColor = kColor_Normal;
        [view addSubview:lab];
        
        UILabel *labResult = [[UILabel alloc] initWithFrame:CGRectMake(12.f, view.mj_h - 20 - 10.f, lab.mj_w, 20)];
        labResult.font = [UIFont fontNormal:15.f];
        labResult.textColor = kColor_Normal;
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
    
    self.labResult.textColor = str.length ? [UIColor redColor] : kColor_Normal;
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
