//
//  YFTagView.m
//  YFTagView
//
//  Created by FYWCQ on 17/3/6.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "YFTagView.h"

#import "YFTagButton.h"

#define RGB_YF(r,g,b) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1.0]

//-- YF_MULTILINE_TEXTSIZE  字体内容多少判断label的size
#define YF_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

@interface YFTagView ()<YFInputTextFieldDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *tgScrollView;

@property(nonatomic, strong)NSMutableArray *tgButtonArray;

@property(nonatomic, strong)NSMutableArray *tagStrings;

// 传入的 不是 字符串的数组时 使用
@property(nonatomic, strong)NSMutableArray *tagModelArray;


@property(nonatomic, strong)UIMenuController *menuController;

@property(nonatomic, strong)YFTagButton *selectButton;

@end

@implementation YFTagView
{
    UIScrollView *_scrollView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

#pragma mark Custom Action

- (void)initSetting
{
    self.viewMaxHeight = [[UIScreen mainScreen] bounds].size.height - 164.0;
    
    _beginxx = _tagPaddingSize.width;
    
    _tagHeight = 26.0;
    
    _tagPaddingSize = CGSizeMake(6, 6);
    _textPaddingSize = CGSizeMake(0, 3);

    _fontTag = [UIFont systemFontOfSize:14];
    _fontInput = [UIFont systemFontOfSize:14];

    _colorTextTag = [UIColor whiteColor];
    _colorTagSelectedBg = RGB_YF(11, 177, 75);
    _colorTagNomalBg = RGB_YF(106, 127, 164);
    _colorTagNomalBg = RGB_YF(161, 180, 214);
    _colorTagBoardNomal = RGB_YF(106, 127, 164);
    _colorTagBoardSelect = _colorTagBoardNomal;
    
    self.minInputWidth = 130;
    
    self.maxInputWidth = 150;
    
    [self addSubview: self.tgScrollView];
    
    [self tgButtonArray];
    [self tagStrings];
    [self menuController];
}

- (void)setPreText:(NSString *)preDesText
{
    CGSize size = YF_MULTILINE_TEXTSIZE(preDesText, _fontTag, CGSizeMake(200, 100), 0);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_tagPaddingSize.width, _tagPaddingSize.height, ceil(size.width) + 4, _tagHeight)];
    label.text = preDesText;
    label.font = _fontTag;
    label.textColor = [UIColor grayColor];
    
    _beginxx = label.frame.size.width + _tagPaddingSize.width;
    [_tgScrollView addSubview:label];
}

- (void)addTags:(NSArray *)tags
{
    
    for (NSString *tag in tags)
    {
        [self addTagToLast:tag];
    }
 
    [self setInputTextFieldFrame];
    
}

- (void)setInputTextFieldFrame
{
    YFTagButton *preButton = _tgButtonArray.lastObject;
    CGRect preFrame;
    if (preButton) {
        preFrame = preButton.frame;
    }else
    {
        preFrame = CGRectMake(_beginxx, _tagPaddingSize.height, 0, 0);
    }

    CGFloat tfXX = preFrame.origin.x + preFrame.size.width + _tagPaddingSize.width;
    CGFloat tfYY = preFrame.origin.y ;
    
    CGFloat maxWidth = _tgScrollView.frame.size.width -  _tagPaddingSize.width;
    CGFloat minWidth = self.minInputWidth;
    CGSize size ;
    CGFloat width;
    if(self.inputTextField.text.length) {
        size = YF_MULTILINE_TEXTSIZE(self.inputTextField.text, self.inputTextField.font, CGSizeMake(1000, _tagHeight), 0);
        width = ceil(size.width) + _tagHeight + 2;
    } else {
        size = CGSizeZero;
        width = minWidth;
    }

    if(width < minWidth) {
        width = minWidth;
    }
    if(width > maxWidth) {
        width = maxWidth;
    }
    
    if (tfXX >= _tgScrollView.frame.size.width - _tagPaddingSize.width - width) {
        
        tfXX = _tagPaddingSize.width;
        
        tfYY += _tagPaddingSize.height + preFrame.size.height;
    }
    
    self.inputTextField.frame = CGRectMake(tfXX, tfYY, width, _tagHeight);
    
    CGFloat height = self.inputTextField.frame.size.height + self.inputTextField.frame.origin.y + _tagPaddingSize.height;
    
    self.tgScrollView.contentSize = CGSizeMake(self.frame.size.width, height);

    
    if (height > self.viewMaxHeight && self.viewMaxHeight != 0)
    {
        height = self.viewMaxHeight;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    
}


- (void)addTagModels:(NSMutableArray *)tags
{
    _tagModelArray = tags;
    for (NSString *tag in tags)
    {
        NSString *strTag;
        if (self.tagModelBlock)
        {
            strTag = self.tagModelBlock(tag);
            [self addTagToLast:strTag];
        }
    }
    [self setInputTextFieldFrame];
}


- (void)addTagToLast:(NSString *)tag
{
    if ([self isExistedSametag:tag])
    {
        return;
    }
    
        [_tagStrings addObject:tag];
        
        YFTagButton* tagButton=[self tagButtonWithTag:tag];
        [tagButton addTarget:self action:@selector(handlerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        NSLog(@"%@",NSStringFromCGRect(tagButton.frame));
        [_tgScrollView addSubview:tagButton];
        [_tgButtonArray addObject:tagButton];
}

- (void)handlerButtonAction:(YFTagButton *)sender
{
    self.selectButton = sender;
    [self showDeleteMenuController];
    
//    NSUInteger index = [_tgButtonArray indexOfObject:sender];
//    sender.selected = !sender.selected;
//    NSLog(@"%ld",index);
}

// 初始化 有选中的
- (void)addTags:(NSArray *)tags selectedTags:(NSArray*)selectedTags{
    [self addTags:tags];
//    self.tagStringsSelected=[NSMutableArray arrayWithArray:selectedTags];
}

- (YFTagButton *)tagButtonWithTag:(NSString *)tag
{
    YFTagButton *preButton = _tgButtonArray.lastObject;
    CGRect preFrame;
    if (preButton) {
        preFrame = preButton.frame;
    }else
    {
        preFrame = CGRectMake(_beginxx, _tagPaddingSize.height, 0, 0);
    }
    
    
    YFTagButton *tagBtn = [[YFTagButton alloc] init];
    
    tagBtn.colorSelectText = _colorSelectText;
    tagBtn.colorTextTag = _colorTextTag;
    
    tagBtn.colorTagNomalBg = _colorTagNomalBg;
    tagBtn.colorTagSelectedBg = _colorTagSelectedBg;
    
    tagBtn.colorTagBoardNomal = _colorTagBoardNomal;
    tagBtn.colorTagBoardSelect = _colorTagBoardSelect;
    
    [tagBtn.titleLabel setFont:_fontTag];
    [tagBtn setBackgroundColor:_colorTagNomalBg];
    [tagBtn setTitleColor:_colorTextTag forState:UIControlStateNormal];
    [tagBtn setTitleColor:_colorSelectText forState:UIControlStateSelected];

//    [tagBtn addTarget:self action:@selector(handlerTagButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [tagBtn setTitle:tag forState:UIControlStateNormal];
    
    CGRect btnFrame;
    btnFrame.size.height = _tagHeight;
    tagBtn.layer.cornerRadius = btnFrame.size.height * 0.5f;

    btnFrame.size.width = ceil( [tag sizeWithAttributes:@{NSFontAttributeName:_fontTag}].width) + (tagBtn.layer.cornerRadius * 2.0f) + _textPaddingSize.width*2;

    // 限制显示的最大宽度
    if (btnFrame.size.width > _tgScrollView.frame.size.width - _tagPaddingSize.width * 2) {
        btnFrame.size.width = _tgScrollView.frame.size.width - _tagPaddingSize.width * 2;
    }
    
    btnFrame = [self setButtonFrameWithPreFrame:preFrame buttonSize:btnFrame.size];
    

    
    tagBtn.frame=btnFrame;
    return tagBtn;
}
- (void)refreshFrameFromIndex:(NSInteger)index
{
    CGRect preIndexFrame;
    if (self.tgButtonArray.count > index - 1 && index > 0)
    {
        preIndexFrame = ((UIButton *)self.tgButtonArray[index - 1]).frame;
    }
    else
    {
        preIndexFrame = CGRectMake(_beginxx, _tagPaddingSize.height, 0, 0);
    }
    
    for (NSInteger i = index; i < self.tgButtonArray.count; i ++)
    {
        UIButton *button = self.tgButtonArray[i];
        
        button.frame = [self setButtonFrameWithPreFrame:preIndexFrame buttonSize:button.frame.size];
        
        preIndexFrame = button.frame;
    }
}

// 根据上一个 tag frame，设置 下一个 frame
- (CGRect)setButtonFrameWithPreFrame:(CGRect)preFrame buttonSize:(CGSize)btnSize
{
    CGRect btnFrame;
    btnFrame.size = btnSize;
    
    CGFloat xxTabBtn = _tagPaddingSize.width + preFrame.origin.x + preFrame.size.width;
    CGFloat yyTabBtn = preFrame.origin.y;
    
    if (xxTabBtn + btnFrame.size.width + _tagPaddingSize.width> _tgScrollView.frame.size.width) {
        xxTabBtn = _tagPaddingSize.width;
        yyTabBtn = preFrame.size.height + preFrame.origin.y + _tagPaddingSize.height;
    }
    
    btnFrame.origin = CGPointMake(xxTabBtn, yyTabBtn);
    
    NSLog(@"%@",NSStringFromCGRect(btnFrame));
    NSLog(@"---------%@",NSStringFromCGRect(preFrame));
    return btnFrame;
}


- (void)handlerTagButtonEvent:(UIButton *)sender
{
    
}


#pragma mark getter & setter
-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    _tgScrollView.backgroundColor = backgroundColor;
}

- (UIScrollView *)tgScrollView
{
    if (_tgScrollView == nil) {
        UIScrollView* sv = [[UIScrollView alloc] initWithFrame: self.bounds];
        sv.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        sv.contentSize = sv.frame.size;
        sv.contentSize = sv.frame.size;
        sv.indicatorStyle = UIScrollViewIndicatorStyleDefault;
        sv.backgroundColor = self.backgroundColor;
        sv.showsVerticalScrollIndicator = YES;
        sv.showsHorizontalScrollIndicator = NO;
        _tgScrollView = sv;
        sv.delegate = self;
    }
    return _tgScrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.selectButton = nil;
}

- (NSMutableArray *)tgButtonArray
{
    if (_tgButtonArray == nil)
    {
        _tgButtonArray = [NSMutableArray array];
    }
    return _tgButtonArray;
}
- (NSMutableArray *)tagStrings
{
    if (_tagStrings == nil)
    {
        _tagStrings = [NSMutableArray array];
    }
    return _tagStrings;
}

- (YFInputTextfield *)inputTextField
{
    if (_inputTextField == nil)
    {
        _inputTextField = [[YFInputTextfield alloc]initWithFrame:CGRectMake(0, 0, 40, _tagHeight)];
        
        _inputTextField.yf_delegate = self;
        
        _inputTextField.delegate = self;
        
        _inputTextField.tintColor = RGB_YF(40, 186, 96);
        
        _inputTextField.font = [UIFont systemFontOfSize:13.0];
        
        [_tgScrollView addSubview:_inputTextField];
        
        _inputTextField.returnKeyType = UIReturnKeyDone;
        
        [_inputTextField addTarget:self action:@selector(textFieldEditedChangeFY:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _inputTextField;
}

- (void)textFieldEditedChangeFY:(UITextField *)textField {
    [self setInputTextFieldFrame];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length) {
        
        
        

        if ([self isExistedSametag:textField.text])
        {
            return  YES;
        }
        id model;
        if (self.tagToModel) {
            model = self.tagToModel(textField.text);
            [_tagModelArray addObject:model];
        }
        [self addTagToLast:textField.text];
        [self setInputTextFieldFrame];
        textField.text = @"";
        [self.tgScrollView scrollRectToVisible:CGRectMake(0, self.tgScrollView.contentSize.height -1, self.frame.size.width, 1) animated:YES];
    }
    return YES;
}

- (BOOL)isExistedSametag:(NSString *)willAddTagString
{
    NSArray *result = [_tagStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF == %@", willAddTagString]];
    if (result.count) {
        NSLog(@"tag 重复");
        return  YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)ynTextFieldDeleteBackward:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
        YFTagButton *button = self.tgButtonArray.lastObject;
        
        if (self.selectButton)
        {
            [self deleteItemClicked:nil];
        }
        else if (button)
        {
            if (button.selected == NO)
            {
                button.selected = YES;
            }
            else
            {
                self.selectButton = button;
                [self deleteItemClicked:nil];
//                NSInteger index = self.tgButtonArray.count - 1;
//                if (_delegate && [_delegate respondsToSelector:@selector(willRemoveTag:index:)])
//                {
//                    if ([_delegate willRemoveTag:self index:index])
//                    {
//                        [self removeTagWithIndex:index];
//                        [self setInputTextFieldFrame];
//                    }
//                }
            }
        }
    }
}

- (void)removeTagWithIndex:(NSInteger)index
{
    YFTagButton *button = self.tgButtonArray[index];
    
    [button removeFromSuperview];
    [self.tgButtonArray removeObjectAtIndex:index];
    [self.tagStrings removeObjectAtIndex:index];
    if (self.tagModelArray.count)
    {
        [self.tagModelArray removeObjectAtIndex:index];
    }
    [self refreshFrameFromIndex:index];
}

- (UIMenuController *)menuController
{
    if (_menuController == nil)
    {
        _menuController = [UIMenuController sharedMenuController];
        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteItemClicked:)];
//        NSAssert([self becomeFirstResponder], @"Sorry, UIMenuController will not work with %@ since it cannot become first responder", self);

        [_menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
//        [_menuController setTargetRect:buttonFrame inView:_svContainer];
//        [_menuController setMenuVisible:YES animated:YES];
        
    }
    return _menuController;
}

- (BOOL) canPerformAction:(SEL)selector withSender:(id) sender {
    if (selector == @selector(deleteItemClicked:) /*|| selector == @selector(copy:)*/ /**<enable that if you want the copy item */) {
        return YES;
    }
    return NO;
}
- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)deleteItemClicked:(UIMenuItem *)item
{
    if (!self.selectButton)
    {
        return;
    }
    NSUInteger index = [_tgButtonArray indexOfObject:self.selectButton];
    
    if (_delegate && [_delegate respondsToSelector:@selector(willRemoveTag:index:)]) {
        if ([_delegate willRemoveTag:self index:index]) {
            [self deleteSelectButton];
            [self setInputTextFieldFrame];
        }
    }else
    {
        [self deleteSelectButton];
        [self setInputTextFieldFrame];
    }
}


- (void)deleteSelectButton
{
    if (self.selectButton)
    {
        NSUInteger index = [_tgButtonArray indexOfObject:self.selectButton];
        [self removeTagWithIndex:index];
    }
       self.selectButton = nil;
}

- (void)setSelectButton:(YFTagButton *)selectButton
{
    
    if (_selectButton.selected && [_selectButton isEqual:selectButton])
    {
        selectButton.selected = NO;
        self.selectButton = nil;
        return;
    }
    
    if (_selectButton) {
        _selectButton.selected = NO;
    }
    
    _selectButton = selectButton;
    
    // Set New Selected Button
    if (selectButton) {
        _selectButton.selected = YES;
    }else // Set nil Selected Button
    {
        if (_menuController.isMenuVisible)
        {
        [_menuController setMenuVisible:NO animated:YES];
        }
    }
}

- (void)showDeleteMenuController
{
    if (_selectButton)
    {
        CGRect buttonFrame=_selectButton.frame;
        buttonFrame.size.height-=5;
        [self becomeFirstResponder];
        
        [_menuController setTargetRect:buttonFrame inView:_tgScrollView];
        [_menuController setMenuVisible:YES animated:YES];

    }
}

- (void)setFrame:(CGRect)frame
{
    CGRect origRect = self.frame;
    [super setFrame:frame];
    
    if (CGRectEqualToRect(origRect, frame) == NO) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(heightDidChangedTagView:)]) {
            [_delegate heightDidChangedTagView:self];
        }
    }
}

- (NSMutableArray *)getDataArray
{
    if (self.tagModelArray)
    {
        return self.tagModelArray;
    }
    return self.tagStrings;
}

@end
