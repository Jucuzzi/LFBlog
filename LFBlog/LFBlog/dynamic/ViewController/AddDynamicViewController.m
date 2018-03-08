//
//  AddDynamicViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/8.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "AddDynamicViewController.h"

@interface AddDynamicViewController ()

@end

@implementation AddDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitle];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化方法
- (void)initData {
    
}

- (void)initTitle {
    self.title = @"发布新动态";
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextView *dynamicContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 20 , SCREEN_WIDTH - 40, 40)];
    [self.view addSubview:dynamicContent];
    dynamicContent.textColor = [UIColor lightGrayColor];
    dynamicContent.font = [UIFont systemFontOfSize:17.f];
    dynamicContent.text = @"分享点好东西...";
    
}


@end
