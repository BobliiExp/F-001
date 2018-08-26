//
//  PYAudioWaveLayer.h
//  PYHero
//
//  Created by Bob Lee on 2018/8/26.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYAudioWaveLayer : CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame;

- (void)updateWave:(NSArray*)waves;

- (void)waveStatusChanged:(BOOL)pause;

@end

NS_ASSUME_NONNULL_END
