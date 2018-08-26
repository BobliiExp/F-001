//
//  PYVCTabMedia.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabMedia.h"
#import "PYVAudioWave.h"
#import "PYIMAudioController.h"
#import "PYAudioWaveLayer.h"
#import "PYVAlertFirst.h"
#import "PYVCOwnSetting.h"
#import "PYVCPointInfo.h"
#import "PYVCHistory.h"
#import "PYCellMediaHistory.h"

#import "PYUserManage.h"
#import "YSCRippleView.h"

#import "PYIMAPIChat.h"

#import "c2c.h"
#import "c2s.h"

#import "PYVCChatAudio.h"

#import <MessageUI/MFMessageComposeViewController.h>

@interface PYVCTabMedia ()<UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate>{
    BOOL isOpen;    ///< 是否展开
}

@property (nonatomic, weak) UITableView *tableView; ///<
@property (nonatomic, weak) PYVAudioWave *viewWave;
@property (nonatomic, weak) PYAudioWaveLayer *layerWave;
@property (nonatomic, strong) PYIMAudioController *audioControl;   ///< 语音控制

@property (nonatomic, weak) YSCRippleView *rippleView;
@property (nonatomic, strong) UIButton *btn; ///< 折叠按钮


@end

static NSString *server = @"ws2.lang365.cn";
static int code = 10102;

@implementation PYVCTabMedia

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tabBarItem.title;
    // Do any additional setup after loading the view.
    
    NSInteger temp = [[NSDate date] timeIntervalSince1970];
    code = [[[NSString stringWithFormat:@"%zi", temp] substringFromIndex:6] intValue];
}

- (void)setupUI {
    
    CGFloat height = kScreenHeight - self.tabBarController.tabBar.frame.size.height;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, height - 40*4, kScreenWidth, 40*4) style:UITableViewStylePlain];
    tableView.backgroundColor = kColor_Content;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.scrollEnabled = NO;
    tableView.allowsSelection = NO;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    YSCRippleView *view = [[YSCRippleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMinY(tableView.frame))];
    [self.view insertSubview:view belowSubview:tableView];
    self.rippleView = view;
    [_rippleView showWithRippleType:YSCRippleTypeLine];
    [view updateButtonFrame:CGRectMake(0, 0, 100, 100)];
    
    @weakify(self);
    [view onButtonClicked:^{
        @strongify(self);
        [self buttonnClicked];
    }];
    
    NSString *isFirst = [PYUserManage py_getStringWithKey:@"isFirst"];
    if (![isFirst isEqualToString:@"YES"]) {
        [PYUserManage py_savePoint:@"20"];
        [PYUserManage py_saveString:@"YES" key:@"isFirst"];
        
        @weakify(self);
        [AFFAlertView alertWithView:[[PYVAlertFirst alloc] init] block:^(NSInteger index, BOOL isCancel) {
            @strongify(self);
            if (index == 10) {
                PYVCOwnSetting *vc = [[PYVCOwnSetting alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (index == 11){
                PYVCPointInfo *vc = [[PYVCPointInfo alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    
}

- (void)setupData {
    [PYIMAPIChat chatObserverServer:^(PYIMError *error) {
        if(error.success){
            switch (error.cmdID) {
                case C2S_HOLE_NOTIFY: {
                    if(kAccount.chatState)return;
                    if(kAccount.toAccount==0)return;
                    
                    // 被人请求打洞，马上回复
                    [PYIMAPIChat chatC2CHole:^(PYIMError *error) {
                        if(!error.success)
                            NSLog(@"%@", error.errDesc);
                    }];
                } break;
                    
                case C2C_HOLE: {
                    if(kAccount.chatState || !error.success)return ;
                    
                    // 被人请求打洞，马上回复
                    [PYIMAPIChat chatC2CHoleResp:error.rspIP port:error.rspPort callback:^(PYIMError *error) {
                        if(!error.success)
                            NSLog(@"%@", error.errDesc);
                    }];
                } break;
                    
                case C2C_REQUEST: {
                    if(kAccount.chatState || !error.success)return ;
                    
                    // 收到请求，先要发一个打洞消息
                    [PYIMAPIChat chatC2CHole:^(PYIMError *error) {
                        if(error.success)
                            NSLog(@"收到请求消息，打洞发送成功");
                    }];
                    
                    // 收到请求确认处理
                    [self actionnRequest];
                } break;
                    
                default: {
                    if(error.cmdID == C2C_CANCEL_REQUEST){
                        [AFFAlertView dismiss];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPY_ResponseServer object:error];
                } break;
            }
            
        }else {
            [kNote writeNote:[NSString stringWithFormat:@"接收到信息但有错误：cmd %04x, ip %@, port %d", error.cmdID, error.rspIP, error.rspPort]];
            NSLog(@"接收到信息但有错误：cmd %04x", error.cmdID);
        }
    }];
    
    // 获取历史记录，刷新列表
    self.mArrData = [PYUserManage py_getMediaData].mutableCopy;
    [self.tableView reloadData];
}

- (void)buttonnClicked {
    [self connect];
}

- (void)setupAlert:(int)code {
    CGFloat paddinng = 10;
    
    UIView *view = [[UIView alloc] init];
    CGRect frame = CGRectMake(paddinng, paddinng, kAlertViewWidth-paddinng*2, 20);
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.textColor = kColor_Title;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"请输入短信中的语音邀请码！";
    [view addSubview:lab];
    
    __block UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake((kAlertViewWidth-100)/2, CGRectGetMaxY(frame)+paddinng, 100, 40)];
    field.placeholder = @"语音邀请码";
    field.layer.borderColor = kColor_Content.CGColor;
    field.layer.borderWidth = 1.0;
    field.textColor = [UIColor blackColor];
    field.font = [UIFont boldSystemFontOfSize:15];
    field.textAlignment = NSTextAlignmentCenter;
    field.keyboardType = UIKeyboardTypeNumberPad;
    [view addSubview:field];
    
    view.frame = CGRectMake(0, 0, kAlertViewWidth, CGRectGetMaxY(field.frame)+paddinng);
    
    [AFFAlertView alertWithView:view btnTitle:@[@"连线好友", @"取消"] block:^(NSInteger index, BOOL isCancel) {
        if(!isCancel){
            if(field.text==nil || field.text.length==0){
                [SVProgressHUD showInfoWithStatus:@"请输入邀请码"];
                return;
            }
            
            [AFFAlertView dismiss];
            
            PYVCChatAudio *audio = [[PYVCChatAudio alloc] init];
            audio.is8kTo8k = YES;
            audio.isCompress = YES;
            audio.toAccount = field.text.intValue;
            [self presentViewController:audio animated:YES completion:NULL];
        }
        
        [SVProgressHUD dismiss];
        [self.rippleView cleanTheme];
    }];
}

- (void)connect {
    if(kAccount.hadLogin){
        // 登录、获取链接秘钥
        [AFFAlertView actionSheetWithTitle:@"语音邀请码已生成，您可以" btnTitle:@[@"邀请好友通话", @"连线好友", @"取消"] block:^(NSInteger index, BOOL isCancel) {
            if(isCancel){
                [_rippleView cleanTheme];
            }else if(index == 0){
                [self invate:[NSString stringWithFormat:@"%d", code]];
            }else if(index == 1){
                [self setupAlert:code];
            }
        }];
    }
    else {
        [SVProgressHUD show];
        [PYIMAPIChat chatConnectHost:server port:10000];
        [PYIMAPIChat chatLogin:code pwd:@"123456" callback:^(PYIMError *error) {
            // 统一操作回调
            if(error.success && kAccount.hadLogin>0){
                [SVProgressHUD dismiss];
                
                // 登录、获取链接秘钥
                [AFFAlertView actionSheetWithTitle:@"语音邀请码已生成，您可以" btnTitle:@[@"邀请好友通话", @"连线好友", @"取消"] block:^(NSInteger index, BOOL isCancel) {
                    if(isCancel){
                        [_rippleView cleanTheme];
                    }else if(index == 0){
                        [self invate:[NSString stringWithFormat:@"%d", code]];
                    }else if(index == 1){
                        [self setupAlert:code];
                    }
                }];
                
            }else {
                code++;
                [SVProgressHUD showErrorWithStatus:error.errDesc];
            }
        }];
    }
}

-(void)invate:(NSString *)code{
    NSInteger coin = [[PYUserManage py_getPoint] integerValue];
    if(coin<10){
        [AFFAlertView alertWithTitle:[NSString stringWithFormat:@"您当前积分为:%zi", coin] content:@"至少需要10积分才能使用语音功能" btnTitle:@[@"赚取积分", @"取消"] block:^(NSInteger index, BOOL isCancel) {
            if(!isCancel){
                self.tabBarController.selectedIndex = 2;
                [AFFAlertView dismiss];
            }
        }];
        return;
    }
    
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDict stringForKey:@"CFBundleDisplayName"];
    
    NSString *strMessage = [NSString stringWithFormat:@"Hi，我正在使用虫洞语音，语音邀请号为:%@, 赶快打开或者下载 “%@” app,开始畅聊吧！", code, appName];
    [self sendSMS:strMessage recipientList:nil];
}

//内容，收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText]){
        controller.body = bodyOfMessage;
        controller.recipients = @[];
        controller.messageComposeDelegate = self;
        //iOS 9.2 要自己写导航栏，和右边按钮
        UINavigationItem *navItem = [[[controller viewControllers] lastObject] navigationItem];
        [navItem setTitle:@"短信邀请"];
        UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(messageVCHide)];
        navItem.rightBarButtonItem = item;
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    [self.rippleView cleanTheme];
}

- (void)messageVCHide{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *str = nil;
    if (result == MessageComposeResultSent){
        str = @"邀请发送成功";
    }
    else{
        str = @"取消邀请";
    }
    
    [SVProgressHUD showInfoWithStatus:str];
}

- (void)actionAudio {
    PYVCChatAudio *audio = [[PYVCChatAudio alloc] init];
    audio.isRequest = YES;
    audio.isCompress = YES;
    audio.is8kTo8k = YES;
    [self presentViewController:audio animated:YES completion:NULL];
}

- (void)actionnRequest {
    [AFFAlertView actionSheetWithTitle:@"收到来自好友的语音请求" btnTitle:@[@"连线语音", @"取消"] block:^(NSInteger index, BOOL isCancel) {
        if(isCancel){
            [PYIMAPIChat chatC2CRequestAccept:NO callback:^(PYIMError *error) {}];
        }else {
            [self actionAudio];
        }
    }];
}

#pragma mark - tableView delegate - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return isOpen ? (self.mArrData.count > 3 ? 3 : self.mArrData.count) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYCellMediaHistory *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[PYCellMediaHistory alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor whiteColor] : [UIColor colorWithARGBString:@"#eeeeee"];
    [cell setupData:self.mArrData[indexPath.row]];
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
    return 50;
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
