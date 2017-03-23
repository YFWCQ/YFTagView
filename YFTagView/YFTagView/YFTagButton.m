//
//  YFTagButton.m
//  YFTagView
//
//  Created by FYWCQ on 17/3/6.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "YFTagButton.h"

@implementation YFTagButton

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor: _colorTagSelectedBg];
        self.layer.borderColor = _colorTagBoardSelect.CGColor;
        [self setTitleColor:_colorSelectText forState:UIControlStateSelected];
    } else {
        [self setBackgroundColor:_colorTagNomalBg];
        self.layer.borderColor = _colorTagBoardNomal.CGColor;
        self.layer.borderWidth = 1.0 / [[UIScreen mainScreen] scale] ;;
        [self setTitleColor:_colorTextTag forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}

@end
