//
//  DiscoverMainViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "DiscoverMainViewController.h"
#import "DiscoverViewModel.h"
#import "UIImageView+WebCache.h"
#import "KafkaRefresh.h"
#import "UIImage+Extension.h"
#import "WGCollectionViewLayout.h"
#import "MYCollectionViewCell.h"

@interface DiscoverMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WGCollectionViewLayoutDelegate>{
}

@property (nonatomic, strong) DiscoverViewModel *viewModel;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation DiscoverMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitle];
    [self initView];
    [self initNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 初始化方法

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    // 创建布局
    
    
    WGCollectionViewLayout *layout = [[WGCollectionViewLayout alloc] init];
//    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 200) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MYCollectionViewCell"];
    [self.view addSubview:self.collectionView];
}

- (void)initTitle {
    self.title = @"发现";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"searchIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(searchUser)];
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userIconChanged) name:@"userIconChanged" object:nil];
}

#pragma mark - delegate


-  (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYCollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"MYCollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];
    
    
    return cell;
    
}


#pragma mark - 云端请求方法
- (void)queryUserListRequestStart {
    @weakify(self);
    [[self.viewModel.queryTagsCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        
    }];
}

#pragma mark - getter&&setter方法
- (DiscoverViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[DiscoverViewModel alloc] init];
    }
    return _viewModel;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(WGCollectionViewLayout *)collectionViewLayout wideForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

//- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}

@end
