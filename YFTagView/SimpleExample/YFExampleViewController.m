//
//  YFExampleViewController.m
//  YFTagView
//
//  Created by FYWCQ on 17/3/7.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "YFExampleViewController.h"

#import "YFTagView.h"


@interface YFExampleViewController ()<EYTagViewDelegate>

@property(nonatomic, strong)YFTagView *tagView;

@end

@implementation YFExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 防止 scrollView 自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    YFTagView *tagView = [[YFTagView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, self.view.frame.size.height - 10)];
    
    // 最大高度
    tagView.viewMaxHeight = 400;
        
    tagView.delegate = self;
    
    [tagView addTags:@[
                       @"dog",
                       @"cat",
                       @"pig",
                       @"duck",
                       @"horse",
                       @"elephant",
                       @"ant",
                       @"fish",
                       @"bird",
                       @"engle",
                       @"snake",
                       @"mouse",
                       @"squirrel",
                       @"beaver",
                       @"kangaroo",
                       @"monkey",
                       @"panda",
                       @"bear",
                       @"lion",
                       ]];
    tagView.inputTextField.placeholder = @"请输入标签";
    
    [self.view addSubview:tagView];
    
    tagView.backgroundColor = [UIColor yellowColor];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 70, [[UIScreen mainScreen] bounds].size.width, 60)];
    
    [button setTitle:@"打印结果" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resultAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)resultAction:(UIButton *)sender
{
    
    NSMutableArray *dataArray = [self.tagView getDataArray];
    
    for (NSString *tagName in dataArray)
    {
        NSLog(@"tagName:%@",tagName);
    }
    
}

- (void)heightDidChangedTagView:(YFTagView *)tagView
{
    NSLog(@"");
}

@end
