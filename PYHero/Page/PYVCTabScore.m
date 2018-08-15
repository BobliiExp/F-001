//
//  PYVCTabScore.m
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabScore.h"
#import "PYTabScoreHeader.h"
#import "PYTabScoreCell.h"
#import "PYTabScoreCurrentCell.h"
#import "PYTabScoreNoticeView.h"

#import <Masonry.h>

static NSString *scoreIdentifier1 = @"scoreIdentifier1";
static NSString *scoreIdentifier2 = @"scoreIdentifier2";

@interface PYVCTabScore () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerAreaBottomContraint;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgVIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgVShare;
@property (weak, nonatomic) IBOutlet UILabel *labArea;
@property (weak, nonatomic) IBOutlet UILabel *labUserinfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewline;

@property (nonatomic, weak) PYTabScoreHeader *tableHeader;
@property (nonatomic, strong) PYTabScoreNoticeView *viewNotice;
@property (nonatomic, strong) NSMutableArray *mArrData;

@end

@implementation PYVCTabScore

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    [self updateHeader];
    
    self.headerTopContraint.constant = -kCurrentStatusBarHeight;
    self.headerHeightContraint.constant = 44+kCurrentStatusBarHeight;
    [self.view layoutIfNeeded];
    
    self.labArea.textColor = kColor_Normal;
    self.labUserinfo.textColor = kColor_Gray;
    self.labArea.font = kFont_XL;
    self.labUserinfo.font = kFont_Small;
    
    self.imgVIcon.userInteractionEnabled = YES;
    [self.imgVIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    self.imgVShare.userInteractionEnabled = YES;
    [self.imgVShare addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    
    self.imgVIcon.layer.cornerRadius = CGRectGetHeight(self.imgVIcon.frame)/2;
    self.imgVIcon.layer.masksToBounds = YES;
    
    PYTabScoreHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"PYTabScoreHeader" owner:nil options:nil] lastObject];
    self.tableView.tableHeaderView = header;
    self.tableHeader = header;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PYTabScoreCell" bundle:nil] forCellReuseIdentifier:scoreIdentifier1];
    [self.tableView registerNib:[UINib nibWithNibName:@"PYTabScoreCurrentCell" bundle:nil] forCellReuseIdentifier:scoreIdentifier2];
    
}

- (void)setupData {
    self.mArrData = [NSMutableArray array];
    
    [self reloadData];
}

- (void)reloadData {
    // 更新导航栏
    
    // 更新tableview header内容
    [self.tableHeader setupData:nil];
    
    // 更新tableview数据
    NSInteger timeNow = [[NSDate date] timeIntervalSince1970];
    for(NSInteger i=0; i<100; i++){
        NSInteger assist = (arc4random() % 200);
        NSInteger kill = (arc4random() % 1000);
        NSInteger death = (arc4random() % 10);
        timeNow -= (arc4random() % 120);
        
        [self.mArrData addObject:@{
                                   @"urlIcon":@"",
                                   @"result":@(i%3==0),
                                   @"resultType":@"",
                                   @"gameType":@"排位赛",
                                   @"kill":@(kill),
                                   @"death":@(death),
                                   @"assist":@(assist),
                                   @"createdTime":@(timeNow),
                                   }];
    }
}

#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrData.count>0?self.mArrData.count+1:0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.row==0 ? scoreIdentifier2 : scoreIdentifier1;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        if(indexPath.row==0)
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PYTabScoreCurrentCell" owner:nil options:nil] lastObject];
        else
            cell = [[[NSBundle mainBundle] loadNibNamed:@"PYTabScoreCell" owner:nil options:nil] lastObject];
    }
    
    if([cell isKindOfClass:[PYTabScoreCurrentCell class]]){
        
    }else {
        NSDictionary *dic = [self.mArrData objectAtIndex:indexPath.row-1];
        [((PYTabScoreCell*)cell) setupData:dic];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row==0 ? 30 : 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 导航栏颜色
    [self updateHeader];
    
    // 触发下拉加载，手动统计下拉offset变化，实现下拉加载动画；自定义view，根据偏移控制rotate，偏移量达到一定值是，在end drag时触发
    if(scrollView.contentOffset.y<=0){
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)updateHeader {
    CGFloat offset = self.tableView.contentOffset.y;
    CGFloat alpha = offset>0?(offset/120):0;
    UIColor *color = [UIColor colorWithARGBString:@"#ffffff" alpha:alpha];
    self.viewHeader.backgroundColor = color;
    
    self.labUserinfo.alpha = alpha;
    
    CGFloat bottom = 10+MIN(fabs(alpha), 1)*5;
    self.headerAreaBottomContraint.constant = bottom;
    
    self.viewline.alpha = alpha;
}

#pragma mark actions

- (void)tapGesture:(UITapGestureRecognizer*)sender {
    if(sender.state == UIGestureRecognizerStateRecognized){
        if([sender.view isEqual:self.imgVIcon]){
            if(self.viewNotice==nil){
                self.viewNotice = [[[NSBundle mainBundle] loadNibNamed:@"PYTabScoreNoticeView" owner:nil options:nil] lastObject];
            }
            
            if(self.viewNotice.superview){
                [self.viewNotice hideNotice];
            }else {
                [self.viewNotice showNotice:self.view];
                [self.viewNotice mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(self.view).mas_offset(10);
                    make.trailing.equalTo(self.view).mas_offset(-10);
                    make.top.equalTo(self.viewHeader).mas_offset(CGRectGetHeight(self.viewHeader.frame));
                }];
            }
        }else if([sender.view isEqual:self.imgVShare]){
            
        }
    }
}

#pragma mark memory management

- (void)cleanSelf {
    if(self.hadCleaned)return;
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeFromSuperview];
    
    if(self.mArrData){
        [self.mArrData removeAllObjects];
        self.mArrData = nil;
    }
    
    self.viewNotice = nil;
    
    [super cleanSelf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
