//
//  MeInfoViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "MeInfoViewController.h"
#import "MeMainViewModel.h"
#import "UserIconViewController.h"
#import "Singleton.h"
#import "UIImageView+WebCache.h"
#import "NickNameModifyViewController.h"
#import "SexModityViewController.h"

@interface MeInfoViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *mainTable;
}

@property (nonatomic, strong) MeMainViewModel *viewModel;

@end

@implementation MeInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

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

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化方法

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
}

- (void)initTitle {
    self.title = @"个人信息";
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, DEFAULT_HEIGHT) style:UITableViewStyleGrouped];
//    mainTable.separatorStyle = NO;
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    [self.view addSubview:mainTable];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userIconChanged) name:@"userIconChanged" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userInfoChanged) name:@"userInfoChanged" object:nil];
}

- (void)userIconChanged {
    [mainTable reloadData];
}

- (void)userInfoChanged {
    [self queryUserInfoRequestStart];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }
    }
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"cell",indexPath.section,indexPath.row]];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"修改头像";
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 10, 60, 60)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[Singleton sharedSingleton].userIconPath] placeholderImage:[UIImage imageNamed:@"user_default"] options:SDWebImageProgressiveDownload];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 30.f;
            [cell.contentView addSubview:imageView];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"修改昵称";
            cell.detailTextLabel.text = [Singleton sharedSingleton].nickName;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"性别";
            if ([[Singleton sharedSingleton].sex isEqualToString:@""]||[Singleton sharedSingleton].sex==nil) {
                cell.detailTextLabel.text = @"点击设置性别";
            } else  {
                cell.detailTextLabel.text = [[Singleton sharedSingleton].sex isEqualToString:@"0"]?@"女":@"男";
            }
        } else if (indexPath.row == 1) {
            cell.textLabel.text = @"生日";
            cell.detailTextLabel.text = ([[Singleton sharedSingleton].birthday isEqualToString:@""]||[Singleton sharedSingleton].birthday==nil)?@"点击设置生日":[Singleton sharedSingleton].birthday;
        } else if (indexPath.row == 2) {
            cell.textLabel.text = @"所在地";
            cell.detailTextLabel.text = ([[Singleton sharedSingleton].address isEqualToString:@""]||[Singleton sharedSingleton].address==nil)?@"点击填写地址":[Singleton sharedSingleton].address;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"签名";
            cell.detailTextLabel.text = ([[Singleton sharedSingleton].sign isEqualToString:@""]||[Singleton sharedSingleton].sign==nil)?@"来点个性签名吧":[Singleton sharedSingleton].sign;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[UserIconViewController alloc]init] animated:YES];
        } else if (indexPath.row == 1) {
            [self.navigationController pushViewController:[[NickNameModifyViewController alloc]init] animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[SexModityViewController alloc]init] animated:YES];
        }
    }
}

- (void)queryUserInfoRequestStart {
    @weakify(self);
    [[self.viewModel.queryUserInfoCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        [mainTable reloadData];
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
