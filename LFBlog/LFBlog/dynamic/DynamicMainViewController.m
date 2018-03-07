//
//  DynamicMainViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/7.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "DynamicMainViewController.h"

@interface DynamicMainViewController ()

@end

@implementation DynamicMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTitle {
    self.title = @"动态";
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
}

@end
