//
//  PYModelSaveMedia.m
//  PYHero
//
//  Created by crow on 2018/8/26.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "PYModelSaveMedia.h"

@implementation PYModelSaveMedia

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startTime = @"";
        self.duration = @"";
        self.point = 0;
        self.beInvited = NO;
    }
    return self;
}

@end
