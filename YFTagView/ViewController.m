//
//  ViewController.m
//  YFTagView
//
//  Created by FYWCQ on 17/3/6.
//  Copyright © 2017年 YFWCQ. All rights reserved.
//

#import "ViewController.h"

#import "YFExampleViewController.h"

#import "YFModelExampleViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
       
}
- (IBAction)exampleAction:(id)sender {
 
    [self.navigationController pushViewController:[[YFExampleViewController alloc] init] animated:YES];
}


- (IBAction)modelExampleAction:(id)sender {
    [self.navigationController pushViewController:[[YFModelExampleViewController alloc] init] animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
