//
//  YFTagView.h
//  YFTagView
//
//  Created by FYWCQ on 17/3/6.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YFInputTextfield.h"

@class YFTagView;
@protocol EYTagViewDelegate <NSObject>

@optional
-(void)heightDidChangedTagView:(YFTagView*)tagView;

/**
 *  @return whether delete
 */
@optional
-(BOOL)willRemoveTag:(YFTagView*)tagView index:(NSInteger)index;
@end

@interface YFTagView : UIView

@property (nonatomic, weak) id<EYTagViewDelegate> delegate;


@property (nonatomic, assign) CGFloat tagHeight;//default

@property (nonatomic, assign) CGFloat viewMaxHeight;

@property (nonatomic) CGSize tagPaddingSize;//top & left
@property (nonatomic) CGSize textPaddingSize;

@property (nonatomic, strong) UIFont *fontTag;
@property (nonatomic, strong) UIFont *fontInput;

@property (nonatomic, strong) UIColor* colorSelectText;
@property (nonatomic, strong) UIColor *colorTextTag;

@property (nonatomic, strong) UIColor *colorTagNomalBg;
@property (nonatomic, strong) UIColor *colorTagSelectedBg;


@property (nonatomic, strong) UIColor *colorTagBoardNomal;
@property (nonatomic, strong) UIColor *colorTagBoardSelect;

@property(nonatomic, strong)YFInputTextfield *inputTextField;

// 输入框 最小宽度
@property(nonatomic, assign)CGFloat minInputWidth;
// 输入框 最大宽度 如果需要固定值，请把最大最小值 设为一样
@property(nonatomic, assign)CGFloat maxInputWidth;

// 从哪个位置开始 排列
@property(nonatomic, assign)CGFloat beginxx;

- (void)addTags:(NSArray *)tags;

- (void)addTagModels:(NSMutableArray *)tags;


// Model Array 时 需要实现 以下两个 block
@property(nonatomic, copy)NSString *(^tagModelBlock)(id);
// 添加时 通过这个block 得到 tagModel
@property(nonatomic, copy)id (^tagToModel)(NSString *tag);

- (void)setPreText:(NSString *)preDesText;

//  得到 编辑后的 数组，如果传入Model返回Model数组，否则是字符串数组
- (NSMutableArray *)getDataArray;
@end
