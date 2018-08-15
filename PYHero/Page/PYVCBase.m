//
//  PYVCBase.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/5.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCBase.h"

@interface PYVCBase ()

@end

@implementation PYVCBase

@synthesize hadCleaned;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupData];
}

#pragma mark ui and data

- (void)setupUI {}
- (void)setupData {}

- (void)reloadData {}
#pragma mark UI theme

// 通过vc挂接监听，通知各个子类更新自己显示控件样式
- (void)appThemeUpdated {
    // 基类判断自己是否当前nav最后一个vc；
    // 自己判断是否当前tab主界面
}

#pragma mark memory management

- (void)cleanCache {}

- (void)reloadCache {}

- (void)cleanSelf {
    self.hadCleaned = YES;
}

- (void)dealloc {
    [self cleanSelf];
    NSLog(@"%@ dealloc", self.class);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
