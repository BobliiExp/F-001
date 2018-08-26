//
//  PYVCPointInfo.m
//  PYHero
//
//  Created by crow on 2018/8/26.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYVCPointInfo.h"

@interface PYVCPointInfo ()

@end

@implementation PYVCPointInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupUI {
    self.title = @"积分说明";
    CGFloat deltaY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    NSArray *arrStr = @[@"积分获取",@"1.用户首次使用会获得20积分。\n2.用户可以在转一转游戏中获得积分。",@"积分使用",@"积分可以在虫洞语音中使用。"];
    UILabel *labTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(12.f, deltaY + 12.f, kScreenWidth - 12.f, 40.f)];
    labTitle1.text = arrStr[0];
    [self.view addSubview:labTitle1];
    
    UILabel *labContent1 = [[UILabel alloc] initWithFrame:CGRectMake(30.f, CGRectGetMaxY(labTitle1.frame) + 8.f, kScreenWidth - 30.f - 12.f, 0)];
    labContent1.numberOfLines = 0;
    labContent1.text = arrStr[1];
    labContent1.mj_h = [labContent1 sizeThatFits:CGSizeMake(labContent1.mj_w, CGFLOAT_MAX)].height;
    [self.view addSubview:labContent1];
    
    UILabel *labTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(12.f, CGRectGetMaxY(labContent1.frame) + 12.f, labTitle1.mj_w, labTitle1.mj_h)];
    labTitle2.text = arrStr[2];
    [self.view addSubview:labTitle2];
    
    UILabel *labContent2 = [[UILabel alloc] initWithFrame:CGRectMake(labContent1.mj_x, CGRectGetMaxY(labTitle2.frame) + 8.f, labContent1.mj_w, 0)];
    labContent2.numberOfLines = 0;
    labContent2.text = arrStr[3];
    labContent2.mj_h = [labContent2 sizeThatFits:CGSizeMake(labContent2.mj_w, CGFLOAT_MAX)].height;
    [self.view addSubview:labContent2];
    
    labTitle1.font = labTitle2.font = kFont_XL;
    labTitle1.textColor = labTitle2.textColor = kColor_Title;
    labContent2.font = labContent1.font = kFont_Normal;
    labContent2.textColor = labContent1.textColor = kColor_Title;
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
