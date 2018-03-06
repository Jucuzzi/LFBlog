//
//  MeMainViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/2.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "MeMainViewController.h"

@interface MeMainViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MeMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitle];
    [self initView];
}

- (void)initTitle {
    self.title = @"我的";
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    UITableView *accountTable = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAV_TITLE_HEIGHT, SCREEN_WIDTH, DEFAULT_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:accountTable];
    
    accountTable.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    accountTable.delegate = self;
    accountTable.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 15;
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
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
                imageView.image = [UIImage imageNamed:@""];
                [cell.contentView addSubview:imageView];
                UILabel *accountNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, SCREEN_WIDTH - 160, 20)];
                accountNameLabel.text = @"王力丰";
                [cell.contentView addSubview:accountNameLabel];
            }
        } else if (indexPath.section == 1) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, 50)];
            titleLabel.font = [UIFont systemFontOfSize:15.f];
            [cell.contentView addSubview:titleLabel];
            if (indexPath.row == 0) {
                titleLabel.text = @"我关注的主题";
            } else if (indexPath.row == 1) {
                titleLabel.text = @"我的收藏";
            } else if (indexPath.row == 2) {
                titleLabel.text = @"我的通知";
            } else if (indexPath.row == 3) {
                titleLabel.text = @"帮助与反馈";
            }
        } else if (indexPath.section == 2) {
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 100, 50)];
            titleLabel.font = [UIFont systemFontOfSize:15.f];
            [cell.contentView addSubview:titleLabel];
            if (indexPath.row == 0) {
                titleLabel.text = @"我创建的主题";
            }
        }
        
    }
    return cell;
}


@end
