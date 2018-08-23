//
//  PYVCTabMain.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabMain.h"

@interface PYVCTabMain ()

@end

@implementation PYVCTabMain

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    /// 隐藏底部 TabBar 的上横线
    for (UIView *view in self.tabBar.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
            UIImageView *ima = (UIImageView *)view;
            ima.hidden = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *config = @[
                        @{@"title":@"虫洞语音", @"icon":@"msg", @"class":@"PYVCTabMedia"},
                        @{@"title":@"摇一摇", @"icon":@"ocean", @"class":@"PYVCTabShake"},
                        @{@"title":@"转一转", @"icon":@"life", @"class":@"PYVCTabLottery"},
                        @{@"title":@"太空捉妖", @"icon":@"work", @"class":@"PYVCTabMonster"},
                        @{@"title":@"我的", @"icon":@"own", @"class":@"PYVCTabOwn"},
                        ];
    
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:config.count];
    
    for(NSDictionary *dic in config){
        UIViewController *vc = [[NSClassFromString(dic[@"class"]) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        UITabBarItem *item = [[UITabBarItem alloc] init];
        [item setSelectedImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_navb_%@_sel", dic[@"icon"]]]];
        [item setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_navb_%@_nor", dic[@"icon"]]]];
        [item setTitle:dic[@"title"]];
        vc.tabBarItem = item;
        
        [mArr addObject:nav];
    }
    
    self.viewControllers = mArr;
    
    self.tabBar.backgroundColor = kColor_Graylight;
    self.tabBar.translucent = YES;
    self.tabBar.shadowImage = [UIImage new]; // 控制下导航条上边线是否显示
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
