//
//  PYVAudioWave.m
//  PYHero
//
//  Created by Bob Lee on 2018/8/23.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVAudioWave.h"

@interface PYVAudioWave() {
    NSArray *arr;
}

@end

@implementation PYVAudioWave

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        
    }
    
    return self;
}

- (void)updateWave:(NSArray*)waves {
    arr = waves;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    if (!arr) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blueColor] setStroke];
    CGContextSetLineWidth(context, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.frame.size.height/2.0);
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat deltaX = CGRectGetWidth(self.frame)/arr.count;
    
    for (int i = 1; i < [arr count]-1; i++) {
        CGFloat scale = ((NSNumber*)arr[i]).floatValue;
        CGContextAddLineToPoint(context, (1+i)*deltaX, height*scale);
    }
    
    CGContextAddLineToPoint(context, SCREEN_WIDTH, self.frame.size.height/2.0);
    CGContextStrokePath(context);
    
}


@end
