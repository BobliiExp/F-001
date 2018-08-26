//
//  PYAudioWaveLayer.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/26.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYAudioWaveLayer.h"

@interface PYAudioWaveLayer()

@property (nonatomic, strong) CADisplayLink *displink;   ///< 刷新
@property (nonatomic, copy) NSArray *arrWave;
@property (nonatomic, assign) BOOL isPause;
@property (nonatomic, assign) NSInteger interval;

@end

@implementation PYAudioWaveLayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if(self){
        self.frame = frame;
        self.lineWidth = 1;
        self.strokeColor = [UIColor greenColor].CGColor;
        self.fillColor = nil; // 默认为blackColor

        _displink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleRefresh)];
        [_displink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return self;
}

- (void)updateWave:(NSArray *)waves {
    if(waves){
        _arrWave = waves;
    }
}

- (void)waveStatusChanged:(BOOL)pause {
    _isPause = pause;
}

- (void)handleRefresh {
    if(_isPause || _arrWave==nil){
        return;
    }
    
    _interval++;
    
    if(_interval==10){
        [self drawPath];
        
        _interval = 0;
    }
}

- (void)drawPath {
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGPoint startPoint = CGPointMake(0, height/2);
    CGPoint endPoint = CGPointMake(width, height/2);
    
    // 绿色二次贝塞尔曲线
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    
    CGFloat deltaX = width/_arrWave.count;
    for(NSInteger i=1; i<_arrWave.count-1; i++){
        NSNumber *number = _arrWave[i];
        
        CGPoint target = CGPointMake(deltaX*i, height*number.floatValue);
        [path addLineToPoint:target];
        
        
//        [path addCurveToPoint:target controlPoint1:CGPointMake(deltaX*i, height) controlPoint2:CGPointMake(150, 125)]; // 二次贝塞尔曲线
    }
    
    [path addLineToPoint:endPoint];
    
    self.path = path.CGPath;
}

@end
