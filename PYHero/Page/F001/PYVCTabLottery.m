//
//  PYVCTabLottery.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/15.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCTabLottery.h"
#import "PYVLottery.h"

@interface PYVCTabLottery (){
    CGFloat _currentTimes;
    NSInteger _currentIndex;
    NSInteger _lastIndex;
    BOOL _isFirst;
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) NSMutableArray *mArrTime;    ///< 时间数组
@property (nonatomic, weak) PYVLottery *vLottery; ///< 转一转视图

@end

@implementation PYVCTabLottery

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.tabBarItem.title;
    // Do any additional setup after loading the view.
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeUI)];
    self.displayLink.paused = YES;
    self.displayLink.frameInterval =1;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)setupUI {
    PYVLottery *vLottery = [[PYVLottery alloc] init];
    vLottery.center = CGPointMake(kScreenWidth/2.f, kScreenHeight/2.f);
    [self.view addSubview:vLottery];
    self.vLottery = vLottery;
    
    [vLottery.btnAction addTarget:self action:@selector(btnActionOnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupData {
    _isFirst = YES;
    _currentIndex = -1;
}

- (void)btnActionOnClicked:(UIButton *)btn {
    NSMutableArray *mArrUp = [NSMutableArray array];
    NSMutableArray *mArrDown = [NSMutableArray array];
    CGFloat numberUp = 2.6;
    CGFloat numberDown = 0.2;
    for (NSInteger i = 0; i < 12; i++) {
        numberUp -= 0.2;
        numberDown += 0.2;
        [mArrUp addObject:@(numberUp)];
        [mArrDown addObject:@(numberDown)];
    }
    
    NSMutableArray *sameSpeedArr =[NSMutableArray array];
    
    NSInteger random = arc4random()%50;
    for (int i = 0; i<(12*7+random); i++) {
        [sameSpeedArr addObject:@(0.1)];
    }
    
    self.mArrTime =[NSMutableArray array];
    [self.mArrTime addObjectsFromArray:mArrUp];
    [self.mArrTime addObjectsFromArray:[sameSpeedArr mutableCopy]];
    [self.mArrTime addObjectsFromArray:mArrDown];
    btn.enabled = NO;
    self.displayLink.paused = NO;
    _lastIndex = 100;
    
    if (_isFirst) {
        _isFirst = NO;
    }else {
        _currentIndex--;
    }
}

- (void)changeUI {
    if (self.mArrTime.count) {
        _currentTimes =_currentTimes+0.1;
        CGFloat delayInSeconds = [[self.mArrTime firstObject] doubleValue];
        NSString *currentTime = [NSString stringWithFormat:@"%.2f",_currentTimes];
        NSString *delaySecond = [NSString stringWithFormat:@"%.2f",delayInSeconds];
        
        if ([currentTime isEqualToString:delaySecond]) {
            _currentTimes = 0;
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *imgV = [self.vLottery.mArrImg objectAtIndex:(++_currentIndex)%(self.vLottery.mArrImg.count)];
                imgV.backgroundColor = [UIColor whiteColor];
                
                if (_lastIndex < 1000) {
                    UIImageView *imgV = [self.vLottery.mArrImg objectAtIndex:_lastIndex%(self.vLottery.mArrImg.count)];
                    imgV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
                }
                _lastIndex = _currentIndex;
            });
            
            [self.mArrTime removeObjectAtIndex:0];
        }
    }else {
        self.vLottery.btnAction.enabled = YES;
        self.displayLink.paused = YES;
    }
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
