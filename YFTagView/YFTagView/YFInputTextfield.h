//
//  YFInputTextfield.h
//  YFTagView
//
//  Created by FYWCQ on 17/3/6.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YFInputTextFieldDelegate <NSObject>

- (void)ynTextFieldDeleteBackward:(UITextField *)textField;

@end

@interface YFInputTextfield : UITextField

@property (nonatomic, weak) id <YFInputTextFieldDelegate> yf_delegate;

@end
