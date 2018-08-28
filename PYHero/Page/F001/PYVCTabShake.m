//
//  PYVCTabShake.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabShake.h"
#import "PYVCShake.h"

@interface PYVCTabShake ()

@end

@implementation PYVCTabShake

- (void)setupUI {
    self.title = self.tabBarItem.title;
    self.view.backgroundColor = [UIColor colorWithARGBString:@"#ACB5D6"];
    
    NSArray *arrTitle = @[@"双色球", @"七乐彩", @"大乐透"];
    NSArray *arrImg = @[@"ic_job_100",@"ic_job_100",@"ic_job_100"];
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    [self.view addSubview:sv];
    
    CGFloat kNavBottom = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat heightView = kScreenHeight - self.tabBarController.tabBar.frame.size.height - kNavBottom;
    
    CGFloat width = 200;
    CGFloat height = 50;
    CGFloat space = 20;
    CGFloat x = (CGRectGetWidth(sv.frame) - width)/2.f;
    CGFloat delatY = 0;
    for (NSInteger i = 0; i<arrTitle.count; i++) {
        UIView *view = [self createButton:CGRectMake(x, delatY, width, height) title:arrTitle[i] img:arrImg[i]];
        view.tag = 10+i;
        [sv addSubview:view];
        
        delatY += (height+space);
    }
    
    sv.mj_h = delatY;
    sv.mj_y = (heightView - delatY)/2.f + kNavBottom;
    sv.contentSize = CGSizeMake(kScreenWidth, delatY);
}

- (UIView *)createButton:(CGRect)frame title:(NSString *)title img:(NSString *)imgName {
    UIView *vbg = [[UIView alloc] initWithFrame:frame];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(vbg.mj_h/2.f, 5, vbg.mj_h-10, vbg.mj_h-10)];
    imgV.image = [UIImage imageNamed:imgName];
    [vbg addSubview:imgV];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(imgV.mj_x+imgV.mj_w, 0, vbg.mj_w - (imgV.mj_x+imgV.mj_w), vbg.mj_h)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = title;
    lab.font = [UIFont fontBold:17.f];
    lab.textColor = kColor_Title;
    [vbg addSubview:lab];
    
    vbg.layer.borderColor = kColor_Background.CGColor;
    vbg.layer.borderWidth = 1.f;
    vbg.layer.cornerRadius = CGRectGetHeight(vbg.frame)/2.f;
    vbg.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnOnClicked:)];
    [vbg addGestureRecognizer:tap];
    return vbg;
}

- (void)btnOnClicked:(UITapGestureRecognizer *)tap {
    PYVCShake *vc = [[PYVCShake alloc] init];
    vc.type = tap.view.tag;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
