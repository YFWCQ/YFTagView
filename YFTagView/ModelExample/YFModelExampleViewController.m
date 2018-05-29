//
//  YFModelExampleViewController.m
//  YFTagView
//
//  Created by FYWCQ on 17/3/17.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "YFModelExampleViewController.h"

#import "YFTagView.h"

#import "YFTestModel.h"

@interface YFModelExampleViewController ()<EYTagViewDelegate>

@property(nonatomic, strong)NSMutableArray *modelArray;

@property(nonatomic, strong)YFTagView *tagView;

@end

@implementation YFModelExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 防止 scrollView 自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    YFTagView *tagView = [[YFTagView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, self.view.frame.size.height - 10)];
    self.tagView =tagView;
    
    [tagView setTagModelBlock:^NSString *(id model) {
        
        return ((YFTestModel *)model).tagName;
    }];
    // 新的tag
    [tagView setTagToModel:^id(NSString *tag) {
        YFTestModel *model = [[YFTestModel alloc] init];
        model.tagName = tag;
        return model;
    }];
    
    tagView.delegate = self;
    
    [tagView addTagModels:self.modelArray];

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
    
    for (YFTestModel *model in dataArray)
    {
        NSLog(@"tagName:%@",model.tagName);
    }
    
}

- (NSMutableArray *)modelArray
{
    if (_modelArray == nil) {
        
        NSArray *dataArray = @[
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
                               ];
        
        _modelArray = [NSMutableArray array];
        for (NSString *string in dataArray)
        {
            YFTestModel *model = [[YFTestModel alloc] init];
            model.tagName = string;
            [_modelArray addObject:model];
        }
    }
    return _modelArray;
}


@end
