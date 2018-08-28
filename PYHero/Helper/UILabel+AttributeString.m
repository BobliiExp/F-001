//
//  UILabel+AttributeString.m
//  PYHero
//
//  Created by crow on 2018/8/28.
//  Copyright © 2018 Bob Lee. All rights reserved.
//

#import "UILabel+AttributeString.h"

@implementation PYModelAttr

- (BOOL)isAvailable {
    unsigned int count = 0;
    //获取属性列表
    Ivar *members = class_copyIvarList([self class], &count);
    BOOL sameCount = YES;
    NSArray *lastArr;
    
    for (int i = 0; i<count; i++) {
        Ivar var = members[i];
        const char *memberType = ivar_getTypeEncoding(var); //获取变量类型
        NSString *typeStr = [NSString stringWithCString:memberType encoding:NSUTF8StringEncoding];
        
        //判断类型
        if ([typeStr isEqualToString:@"@\"NSArray\""]) {
            NSArray *arr = object_getIvar(self, var);
            if (arr) {
                if (lastArr) {
                    if (lastArr.count != arr.count) {
                        sameCount = NO;
                        break;
                    }
                }
                
                lastArr = arr;
            }
        }
    }
    
    return sameCount;
}

@end

@implementation UILabel (AttributeString)

- (void)setAttributedTextWithModel:(PYModelAttr *)model {
    if (model.isAvailable) {
        NSInteger count = model.arrText.count;
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] init];
        
        for (NSInteger i = 0; i < count; i++) {
            NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
            if (model.arrFgColor) {
                [mDic setObject:model.arrFgColor[i] forKey:NSForegroundColorAttributeName];
            }
            
            if (model.arrFont) {
                [mDic setObject:model.arrFont[i] forKey:NSFontAttributeName];
            }
            
            [mAttr appendAttributedString:[[NSAttributedString alloc] initWithString:model.arrText[i] attributes:mDic]];
        }
        
        self.attributedText = mAttr;
    }else {
        NSMutableString *mStr = [NSMutableString string];
        for (NSString *str in model.arrText) {
            [mStr appendString:str];
        }
        self.text = mStr;
    }
}

@end
