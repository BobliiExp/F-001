//
//  PYVCTabNews.m
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabNews.h"
#import "PYPageScrollView.h"

@interface PYVCTabNews () <PYPageScrollViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopContraint;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIcon;
@property (weak, nonatomic) IBOutlet UIView *viewUserBadge;
@property (weak, nonatomic) IBOutlet UIImageView *imgVSearch;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVActivities;
@property (weak, nonatomic) IBOutlet PYPageScrollView *scrollVPages;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (nonatomic, weak) UIView *viewSelected;   ///< 导航栏选中项底色
@property (nonatomic, weak) UILabel *labSelected;   ///< 导航栏选中的栏目
@property (nonatomic, copy) NSArray *arrActivity;    ///< 分类


@end

@implementation PYVCTabNews

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    // 状态栏高度处理
    self.headerTopContraint.constant = kCurrentStatusBarHeight;
    [self.view layoutIfNeeded];
    
    // 红点提示
    self.viewUserBadge.layer.cornerRadius = CGRectGetHeight(self.viewUserBadge.frame)/2;
    self.viewUserBadge.layer.masksToBounds = YES;
    self.viewUserBadge.hidden = YES;
    
    self.imgVIcon.userInteractionEnabled = YES;
    [self.imgVIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    self.imgVSearch.userInteractionEnabled = YES;
    [self.imgVSearch addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    
    self.imgVIcon.layer.cornerRadius = CGRectGetHeight(self.imgVIcon.frame)/2;
    self.imgVIcon.layer.masksToBounds = YES;
    self.scrollVPages.datasource = self;
//    self.scrollVPages.lowMemoryEnable = YES;    // 根据业务情况控制此属性
}

- (void)setupData {
    // 初始化activity数据
    self.arrActivity = @[@{@"最新":@"PYVCNewsNewest"},
                         @{@"赛事":@"PYVCNewsGame"},
                         @{@"英雄":@"PYVCNewsHero"},
                         @{@"活动":@"PYVCNewsActivity"},
                         @{@"专栏":@"PYVCNewsSpecial"},
                         @{@"官方":@"PYVCNewsOfficial"},
                         @{@"名人堂":@"PYVCNewsFamous"},
                         ];
    
    CGFloat width = 60;
    __block CGRect frame = CGRectMake(0, 0, width, CGRectGetHeight(self.scrollVActivities.frame));
    
    if(self.viewSelected==nil) {
        CGRect framex = CGRectInset(frame, 5, 0);
        framex.size.height = 2;
        framex.origin.y = CGRectGetHeight(frame)-CGRectGetHeight(framex);
        UIView *viewSel = [[UIView alloc] initWithFrame:framex];
        viewSel.layer.cornerRadius = CGRectGetHeight(viewSel.frame)/2;
        viewSel.layer.masksToBounds = YES;
        viewSel.layer.backgroundColor = kColor_HighLight.CGColor;
        [self.scrollVActivities addSubview:viewSel];
        self.viewSelected = viewSel;
    }
    
    for(UIView *view in self.scrollVActivities.subviews){
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    
    [self.arrActivity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        
        frame.origin.x = idx*width;
        UILabel *lab = [[UILabel alloc] initWithFrame:frame];
        lab.font = kFont_XL;
        lab.textColor = kColor_Normal;
        lab.text = [dic allKeys][0];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.tag = idx+10000;
        lab.userInteractionEnabled = YES;
        [lab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
        [self.scrollVActivities addSubview:lab];
    }];
    
    self.scrollVActivities.contentSize = CGSizeMake(CGRectGetMaxX(frame), 0);
    [self.scrollVPages reloadData];
}

#pragma mark PYPageScrollView

- (NSInteger)numberOfPage:(PYPageScrollView *)pageScrollView {
    return self.arrActivity.count;
}

- (UIViewController*)pageScrollView:(PYPageScrollView *)pageScrollView viewControllerForPage:(NSInteger)index {
    NSDictionary *dic = self.arrActivity[index];
    Class cls = NSClassFromString([dic allValues][0]);
    
    // 注意这里结合self.scrollVPages.lowMemoryEnable 控制，如果采用低内存占用模式，这里不用判断是否存在；否则避免页面刷新平凡，可以增加相关策略制定刷新
    BOOL exist = YES;
    
    PYVCBase *vc = (PYVCBase*)[pageScrollView dequeueReusableViewControllerWithClassName:cls];
    if(vc==nil){
        vc = [[cls alloc] init];
        exist = NO;
    }
    
    // refresh view data if needed
    if(!exist)
        [vc reloadData];
    
    return vc;
}

- (void)pageScrollViewDidScroll:(PYPageScrollView *)pageScrollView {
    if(self.viewSelected){
        CGFloat scrollProgress = pageScrollView.contentOffset.x/pageScrollView.frame.size.width;
        UIView *viewAct = [self.scrollVActivities viewWithTag:10000];
        CGRect frame = self.viewSelected.frame;
        frame.origin.x = CGRectGetWidth(viewAct.frame)*scrollProgress+(CGRectGetWidth(viewAct.frame)-CGRectGetWidth(self.viewSelected.frame))/2;
        self.viewSelected.frame = frame;
    }
}

- (void)pageScrollViewWillBeginDragging:(PYPageScrollView *)pageScrollView {
    
}

- (void)pageScrollViewDidEndDecelerating:(PYPageScrollView *)pageScrollView {
    
}

- (void)pageScrollViewDidEndDragging:(PYPageScrollView *)pageScrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)pageScrollView:(PYPageScrollView *)pageScrollView willChangeToIndex:(NSInteger)pageIndex {
    
}

- (void)pageScrollView:(PYPageScrollView *)pageScrollView didChangeToIndex:(NSInteger)pageIndex {
    UILabel *labC = self.labSelected;
    labC.font = kFont_XL;
    labC.textColor = kColor_Normal;
    
    UILabel *lab = [self.scrollVActivities viewWithTag:self.scrollVPages.currentPage+10000];
    self.labSelected = lab;
    lab.font = kFont_XXL;
    lab.textColor = kColor_HighLight;
    
    CGFloat duration = 0.25;
    
    // 检查是否滚动activity栏目
    CGFloat minX = CGRectGetMinX(lab.frame);
    CGFloat maxX = CGRectGetMaxX(lab.frame);
    CGFloat cfact = self.scrollVActivities.contentOffset.x;
    CGFloat wact = CGRectGetWidth(self.scrollVActivities.frame);
    CGFloat delta = (minX-cfact)<=0 ? (minX-cfact) : (cfact+wact)<maxX ? (maxX-cfact-wact) : 0;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        if(delta!=0)
            self.scrollVActivities.contentOffset = CGPointMake(cfact+delta, 0);
        
    } completion:NULL];
}

- (void)pageScrollViewWillCleanViewController:(PYPageScrollView *)pageScrollView vc:(UIViewController *)vc {
    [(PYVCBase*)vc cleanSelf];
}

#pragma mark actions

- (void)tapGesture:(UITapGestureRecognizer*)sender {
    if(sender.state == UIGestureRecognizerStateRecognized){
        if([sender.view isKindOfClass:[UILabel class]]){
            [self.scrollVPages jumpPageToIndex:sender.view.tag-10000];
        }else if([sender.view isEqual:self.imgVIcon]){
            self.viewUserBadge.hidden = !self.viewUserBadge.hidden;
        }else if([sender.view isEqual:self.imgVSearch]){
            
        }
    }
}

#pragma mark memory management

- (void)cleanSelf {
    if(self.hadCleaned)return;
    
    self.scrollVPages.datasource = nil;
    [self.scrollVPages cleanSelf];
    [self.scrollVPages removeFromSuperview];
    
    self.arrActivity = nil;
    
    [super cleanSelf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self.scrollVPages cleanCache];
}

@end
