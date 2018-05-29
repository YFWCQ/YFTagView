# YFTagView
 
 
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
