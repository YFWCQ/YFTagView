//
//  YFInputTextfield.m
//  YFTagView
//
//  Created by FYWCQ on 17/3/6.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "YFInputTextfield.h"

@implementation YFInputTextfield

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 9 , 0 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 9 , 0 );
}

- (void)deleteBackward {
    
    if ([self.yf_delegate respondsToSelector:@selector(ynTextFieldDeleteBackward:)]) {
        [self.yf_delegate ynTextFieldDeleteBackward:self];
    }
    //    ！！！这里要调用super方法，要不然删不了东西
    [super deleteBackward];
}


@end
