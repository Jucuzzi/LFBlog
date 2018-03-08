//
//  DynamicMainViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/7.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "DynamicMainViewController.h"
#import "AddDynamicViewController.h"
#import "UIImageView+WebCache.h"
#import "Singleton.h"

@interface DynamicMainViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *DynamicMainTable;
}

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
    DynamicMainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , DEFAULT_HEIGHT) style:UITableViewStyleGrouped];
    DynamicMainTable.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    DynamicMainTable.separatorStyle = NO;
    DynamicMainTable.dataSource = self;
    DynamicMainTable.delegate = self;
    [self.view addSubview:DynamicMainTable];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
                [iconImage sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].userIconPath] placeholderImage:[UIImage imageNamed:@"User_blue_default_userPhoto"]];
                iconImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
                iconImage.layer.cornerRadius = 25.f;
                iconImage.layer.masksToBounds = YES;
                iconImage.layer.borderWidth = 0.5f;
                [cell.contentView addSubview:iconImage];
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 180, 80)];
                titleLabel.font = [UIFont systemFontOfSize:15.f];
                titleLabel.text = @"发布动态....";
                titleLabel.textColor = [UIColor lightGrayColor];
                [cell.contentView addSubview:titleLabel];
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AddDynamicViewController *addDynamic = [[AddDynamicViewController alloc]init];
            addDynamic.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addDynamic animated:YES];
        }
    }
}

@end
