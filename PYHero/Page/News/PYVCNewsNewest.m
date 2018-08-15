//
//  PYVCNewsNewest.m
//  PYHero
//
//  Created by Bob Lee on 2018/3/30.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCNewsNewest.h"
#import "NSDate+PYHero.h"
#import "UIImage+PYHero.h"

#import <MJRefresh.h>
#import <UIImageView+WebCache.h>

#define kImageDefault [UIImage getCornerImageFromImage:[UIImage imageNamed:@"ic_news_default"] containerFrame:CGRectMake(0, 0, 90, 60) withRadious:5 cornerMask:EImageRadiusTopRight|EImageRadiusBottomLeft]

typedef NS_ENUM(NSInteger, PYNewType) {
    EPYNewNone,      ///< 默认
    EPYNewAct,       ///< 活动
    EPYNewNews,      ///< 新闻
    EPYNewNotice,    ///< 公告
};

@interface PYVCNewsNewest () <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mArrData;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation PYVCNewsNewest

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setupUI {
    self.tableView.tableHeaderView = [self customTableViewHeader];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData:YES];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadData:NO];
    }];
}

- (void)setupData{
    self.mArrData = [NSMutableArray array];
    [self reloadData];
}

- (void)reloadData {
    [self.mArrData removeAllObjects];
    [self.tableView reloadData];
    
    [self loadData:YES];
}

- (NSArray*)titles {
    if(_titles==nil){
        _titles = @[@"助威KPL春季赛“魔音”限时返场",
                    @"关于王者荣耀助手动态模块暂时关闭的说明",
                    @"今晚8点| 《王者历史课》第二季欢乐开播",
                    @"王者小报为你密切追踪雨神萧敬腾动向！",
                    @"【高校联赛复习手册】新鲜赛场资讯，浙大强势来袭",
                    ];
    }
    
    return _titles;
}

- (void)loadData:(BOOL)isNew {
    BOOL pullDown = isNew;
    if(self.mArrData.count==0)
        pullDown = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = pullDown?[self.mArrData firstObject]:[self.mArrData lastObject];
        NSInteger timeDisp = ((NSNumber*)dic[@"createdTime"]).integerValue;
        NSInteger timeNow = [[NSDate date] timeIntervalSince1970];
        
        NSInteger count = 10;
        if(pullDown){
            count = (timeNow-timeDisp<60) ? 0 : timeDisp==0 ? 10 : ((timeNow-timeDisp)/60);
            count = MIN(count, 10);
        }else {
            count = (arc4random() % 10) + 1;
        }
        
        if(pullDown)
            timeDisp = timeNow;
        
        timeDisp--;
        
        for(NSInteger i=0; i<count; i++){
            NSInteger assist = (arc4random() % 10000) + 1;
            NSInteger comment = (arc4random() % 1000) + 1;
            
            NSDictionary *dic = @{@"title":self.titles[arc4random() % self.titles.count],
                                  @"nType":@(assist%2==0 ? EPYNewAct : assist%5==0 ? EPYNewNews : assist%7==0 ? EPYNewNotice : EPYNewNone),
                                  @"hasVideo":@(assist%3==0),
                                  @"urlImage": assist%2==0 ? @"http://goldmallmyerm.anyfish.com/userfile/upload/2017/07-03/14990490540090992500296679891115.jpg" : @"",
                                  @"createdTime":@(timeDisp - (pullDown ? (60*(count-i)) : 60*i)),
                                  @"assist":@(assist),
                                  @"comment":@(comment)
                                  };
            
            if(pullDown){
                [self.mArrData insertObject:dic atIndex:0];
            }else {
                [self.mArrData addObject:dic];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
            if(isNew)
                [self.tableView.mj_header endRefreshing];
            else
                [self.tableView.mj_footer endRefreshing];
        });
    });
    
}

- (NSString*)getNewsTypeDesc:(PYNewType)nType {
    switch (nType) {
        case EPYNewAct: { return @"活动"; }
        case EPYNewNews: { return @"新闻"; }
        case EPYNewNotice: { return @"公告"; }
            
        default: { return nil; }
    }
}

#pragma mark UITableView stuff

// 这里可以采用PYPageScrollView实现轮播滚动
- (UIView*)customTableViewHeader {
    CGFloat rate = 237.0/508;
    CGFloat width = CGRectGetWidth(self.tableView.frame);
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width*rate)];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.image = [UIImage imageNamed:@"ic_news_ads"];
    imgV.clipsToBounds = YES;
    
    return imgV;
}

// 这里也可以通过xib配置
- (UITableViewCell*)customTableViewCell:(NSString*)identifier hasImg:(BOOL)hasImg hasVideo:(BOOL)hasVideo {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    CGFloat padding = 10;   // 对外距离
    CGFloat margin = 5;     // 对内距离
    CGFloat height = 20;    // 文本高低，图片高度*3
    CGFloat widthCell = CGRectGetWidth(self.view.frame);
    CGFloat widthImg = 90;  // 图片陶都
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, widthCell-padding*2-(hasImg?margin+widthImg:0), height*2)];
    labTitle.font = kFont_XL;
    labTitle.textColor = kColor_Normal;
    labTitle.tag = 10100;
    [cell.contentView addSubview:labTitle];
    
    // 类型和时间
    UILabel *labType = [[UILabel alloc] initWithFrame:CGRectMake(padding, CGRectGetMaxY(labTitle.frame), CGRectGetWidth(labTitle.frame)/2, height)];
    labType.font = kFont_Normal;
    labType.textColor = kColor_Gray;
    labType.tag = 10101;
    [cell.contentView addSubview:labType];
    
    // 以下通过富文本实现会更简单
    CGFloat widthAC = 35;
    CGFloat widthIcon = 20;
    UIImageView *imgVAssist = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labTitle.frame)-widthAC*2-widthIcon*2-margin, CGRectGetMaxY(labTitle.frame), widthIcon, widthIcon)];
    imgVAssist.image = [UIImage imageNamed:@"ic_news_assist"];
    imgVAssist.contentMode = UIViewContentModeCenter;
    [cell.contentView addSubview:imgVAssist];
    
    UILabel *labAssist = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgVAssist.frame), CGRectGetMaxY(labTitle.frame), widthAC, height)];
    labAssist.font = kFont_Normal;
    labAssist.textColor = kColor_Gray;
    labAssist.tag = 10102;
    [cell.contentView addSubview:labAssist];
    
    UIImageView *imgVCom = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labAssist.frame)+margin, CGRectGetMaxY(labTitle.frame), widthIcon, widthIcon)];
    imgVCom.image = [UIImage imageNamed:@"ic_news_comment"];
    imgVCom.contentMode = UIViewContentModeCenter;
    [cell.contentView addSubview:imgVCom];
    
    UILabel *labCom = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgVCom.frame), CGRectGetMaxY(labTitle.frame), widthAC, height)];
    labCom.font = kFont_Normal;
    labCom.textColor = kColor_Gray;
    labCom.tag = 10103;
    [cell.contentView addSubview:labCom];
    
    if(hasImg){
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(widthCell-padding-widthImg, padding, widthImg, height*3)];
        imgV.contentMode = UIViewContentModeScaleToFill;
        imgV.tag = 10104;
        [cell.contentView addSubview:imgV];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArrData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.mArrData[indexPath.row];
    BOOL hasVideo = ((NSNumber*)dic[@"hasVideo"]).boolValue;
    NSString *urlImage = dic[@"urlImage"];
    PYNewType nType = (PYNewType)((NSNumber*)dic[@"nType"]).integerValue;
    NSString *typeDesc = [self getNewsTypeDesc:nType];
    NSInteger createdTime = ((NSNumber*)dic[@"createdTime"]).integerValue;
    NSInteger assist = ((NSNumber*)dic[@"assist"]).integerValue;
    NSInteger comment = ((NSNumber*)dic[@"comment"]).integerValue;
    
    NSString *identifier = urlImage.length>0 ? @"reuserIdImg" : @"reuseId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell==nil){
        cell = [self customTableViewCell:identifier hasImg:urlImage.length>0 hasVideo:hasVideo];
    }
    
    UILabel *lab = [cell.contentView viewWithTag:10100];
    lab.text = dic[@"title"];
    
    lab = [cell.contentView viewWithTag:10101];
    lab.text = [NSString stringWithFormat:@"%@%@%@", typeDesc?typeDesc:@"", typeDesc?@" ":@"", [NSDate date2StringWithInterval:createdTime]];
    
    lab = [cell.contentView viewWithTag:10102];
    lab.text = [NSString stringWithFormat:@"%ti", assist];
    
    lab = [cell.contentView viewWithTag:10103];
    lab.text = [NSString stringWithFormat:@"%ti", comment];
    
    if(urlImage.length>0){
        // 这里从服务器图片采集就可以优化，到客户端存在异步、裁剪、圆角等处理会降低效率，异步处理会导致闪动
        UIImageView *imgV = [cell.contentView viewWithTag:10104];
        @weakify(self);
        [imgV sd_setImageWithURL:[NSURL URLWithString:urlImage] placeholderImage:kImageDefault completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            @strongify(self);
            if(image){
                [self getCornerImage:image frame:imgV.frame hasVideo:hasVideo block:^(UIImage *img) {
                    imgV.image = img;
                    img = nil;
                }];
            }
        }];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 动态高度，如果有对象可以缓存计算后高度
    return 10+60+10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getCornerImage:(UIImage*)image frame:(CGRect)frame hasVideo:(BOOL)hasVideo block:(void(^)(UIImage *img))block {
    __block UIImage *temp = image;
    // 这里获取到的图片可能过大，导致后期处理内存暴增，所以这里先根据当前界面业务进行压缩；另外跨线程会导致内存拷贝，image过大也会增加内存消耗
    if(image.size.width>frame.size.width*2 || image.size.height>frame.size.height*2){
        temp = [UIImage adaptToSize:image size:CGSizeMake(frame.size.width*2, frame.size.height*2)];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(hasVideo){
            UIImage *imgR = [UIImage imageNamed:@"ic_news_video_play"];
            temp = [UIImage mergeImage:temp withImage:imgR sizeFirst:frame.size sizeSec:imgR.size];
        }
        
        temp = [UIImage getCornerImageFromImage:temp containerFrame:frame withRadious:5 cornerMask:EImageRadiusTopRight|EImageRadiusBottomLeft];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(temp);
        });
    });
}

#pragma mark memory management

- (void)cleanSelf {
    if(self.hadCleaned)return;
    
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.tableView removeFromSuperview]; // 经过调试没有调用移除，不会立即调用dealloc
    
    if(self.mArrData){
        [self.mArrData removeAllObjects];
        self.mArrData = nil;
    }
    
    self.titles = nil;
    
    [super cleanSelf];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
