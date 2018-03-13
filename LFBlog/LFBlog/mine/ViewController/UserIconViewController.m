//
//  UserIconViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "UserIconViewController.h"
#import "MeMainViewModel.h"
#import "UIImageView+WebCache.h"
#import "Singleton.h"
#import "LFHeadImageUtil.h"

@interface UserIconViewController (){
    UIImageView *imageView;
}

@property (nonatomic, strong) MeMainViewModel *viewModel;

@property (nonatomic, strong) LFHeadImageUtil *headImageUtil;

@end

@implementation UserIconViewController

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

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - 初始化方法

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
}

- (void)initTitle {
    self.title = @"个人头像";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleDone target:self action:@selector(changeImage)];
}

- (void)initView {
    self.view.backgroundColor = [UIColor blackColor];
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    imageView.center = CGPointMake(SCREEN_WIDTH/2, DEFAULT_HEIGHT/2 - NAV_TITLE_HEIGHT);
    [imageView sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].userIconPath] placeholderImage:nil options:SDWebImageProgressiveDownload];
    [self.view addSubview:imageView];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userIconChanged) name:@"userIconChanged" object:nil];
}

- (void)userIconChanged {
    
}

///点击头像
- (void)changeImage {
    _headImageUtil = [[LFHeadImageUtil alloc] init];
    __weak __typeof__(self) weakSelf = self;
    [_headImageUtil showWithCallBack:^(UIImage *headImage) {
        weakSelf.viewModel.userIcon = headImage;
        [weakSelf updateUserPhotoRequestStart];
    }];
}

- (void)updateUserPhotoRequestStart {
    @weakify(self);
    [[self.viewModel.uploadUserIconCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        if ([returnData[@"result"]isEqualToString:@"successed"]) {
            [self queryUserInfoRequestStart];
        }
    }];
}

- (void)queryUserInfoRequestStart {
    @weakify(self);
    [[self.viewModel.queryUserInfoCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"userIconChanged" object:nil];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].userIconPath] placeholderImage:nil options:SDWebImageProgressiveDownload];
    }];
}

#pragma mark - getter&&setter方法

- (MeMainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MeMainViewModel alloc] init];
    }
    return _viewModel;
}



@end
