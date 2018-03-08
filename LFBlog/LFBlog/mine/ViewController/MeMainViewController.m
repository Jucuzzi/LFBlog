//
//  MeMainViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/2.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "MeMainViewController.h"
#import "UIImageView+WebCache.h"
#import "Singleton.h"
#import "MeMainViewModel.h"
#import "LFHeadImageUtil.h"
#import "MeInfoViewController.h"

@interface MeMainViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
}
///更换头像工具类
@property (nonatomic, strong) LFHeadImageUtil *headImageUtil;

@property (nonatomic, strong) MeMainViewModel *viewModel;

@end

@implementation MeMainViewController

#pragma mark - 生命周期方法
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
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    
}

- (void)initTitle {
    self.title = @"我的";
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    UITableView *accountTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DEFAULT_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:accountTable];
    
    accountTable.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    accountTable.separatorStyle = NO;
    accountTable.delegate = self;
    accountTable.dataSource = self;
}



#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 4;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    } else if (indexPath.section == 1) {
        return 50;
    } else if (indexPath.section == 2) {
        return 50;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    backgroundView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    return backgroundView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 80)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].userIconPath] placeholderImage:nil options:SDWebImageProgressiveDownload];
                imageView.layer.masksToBounds = YES;
                imageView.layer.cornerRadius = 40.f;
                [cell.contentView addSubview:imageView];
                UILabel *accountNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 25, SCREEN_WIDTH - 200, 20)];
                accountNameLabel.text = @"王力丰";
                accountNameLabel.font = [UIFont systemFontOfSize:17.f];
                [cell.contentView addSubview:accountNameLabel];
                UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 55, SCREEN_WIDTH - 200, 20)];
//                detailLabel.text = [Singleton sharedSingleton].nickName;
                detailLabel.text = @"查看个人资料";
                detailLabel.textColor = [UIColor lightGrayColor];
                detailLabel.font = [UIFont systemFontOfSize:15.f];
                [cell.contentView addSubview:detailLabel];
            }
        } else if (indexPath.section == 1) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, SCREEN_WIDTH - 100, 50)];
            titleLabel.font = [UIFont systemFontOfSize:15.f];
            [cell.contentView addSubview:titleLabel];
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
            [cell.contentView addSubview:iconView];
            if (indexPath.row == 0) {
                iconView.image = [UIImage imageNamed:@"care"];
                titleLabel.text = @"我关注的主题";
            } else if (indexPath.row == 1) {
                iconView.image = [UIImage imageNamed:@"collection"];
                titleLabel.text = @"我的收藏";
            } else if (indexPath.row == 2) {
                iconView.image = [UIImage imageNamed:@"notice"];
                titleLabel.text = @"我的通知";
            } else if (indexPath.row == 3) {
                iconView.image = [UIImage imageNamed:@"help"];
                titleLabel.text = @"帮助与反馈";
            }
        } else if (indexPath.section == 2) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, SCREEN_WIDTH - 100, 50)];
            titleLabel.font = [UIFont systemFontOfSize:15.f];
            [cell.contentView addSubview:titleLabel];
            UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 30, 30)];
            [cell.contentView addSubview:iconView];
            if (indexPath.row == 0) {
                iconView.image = [UIImage imageNamed:@"make"];
                titleLabel.text = @"我创建的主题";
            }
        }
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[MeInfoViewController alloc]init] animated:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

///点击头像
- (void)headImgClick {
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
        NSLog(@"成功了吗");
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
