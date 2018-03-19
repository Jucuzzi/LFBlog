//
//  AddCareViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/16.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "AddCareViewController.h"
#import "DynamicViewModel.h"
#import "UIImageView+WebCache.h"
#import "KafkaRefresh.h"
#import "UIImage+Extension.h"

@interface AddCareViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *mainTableView;
}

@property (nonatomic, strong) DynamicViewModel *viewModel;
@property (nonatomic, strong) NSString *condition;

@end

@implementation AddCareViewController

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
#pragma mark - 初始化方法

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    self.condition = @"";
    [self queryUserListRequestStart];
}

- (void)initTitle {
    self.title = @"发现玖友";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"searchIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(searchUser)];
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DEFAULT_HEIGHT) style:UITableViewStyleGrouped];
    mainTableView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [mainTableView bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                          fillColor:DEFAULT_BLUE_COLOR
                         atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                             [self queryUserListRequestStart];
                         }];
    [self.view addSubview:mainTableView];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userIconChanged) name:@"userIconChanged" object:nil];
}

- (void)userIconChanged {
    [mainTableView reloadData];
}


#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.userList count];
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
        NSDictionary *cellData = self.viewModel.userList[indexPath.row];
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LFBlogUserIconPath,cellData[@"userIconPath"]]] placeholderImage:[UIImage imageNamed:@"user_default"] options:SDWebImageProgressiveDownload];
        iconImageView.layer.masksToBounds = YES;
        iconImageView.layer.cornerRadius = 25.f;
        [cell.contentView addSubview:iconImageView];
        UILabel *accountNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, SCREEN_WIDTH - 200, 20)];
        accountNameLabel.text = cellData[@"nickName"];
        accountNameLabel.font = [UIFont systemFontOfSize:17.f];
        [cell.contentView addSubview:accountNameLabel];
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, SCREEN_WIDTH - 200, 15)];
        //                detailLabel.text = [Singleton sharedSingleton].nickName;
        detailLabel.text = cellData[@"sign"];
        detailLabel.textColor = [UIColor lightGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:13.f];
        [cell.contentView addSubview:detailLabel];
        
        UIButton *careButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100, 25, 60, 30)];
        [careButton setBackgroundImage:[UIImage imageFromColor:DEFAULT_BLUE_COLOR size:CGSizeMake(60, 30)] forState:UIControlStateNormal];
        [careButton setTitle:@"关注" forState:UIControlStateNormal];
        careButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        careButton.titleLabel.textColor = [UIColor whiteColor];
        careButton.layer.cornerRadius = 15.f;
        careButton.layer.masksToBounds = YES;
        [cell.contentView addSubview:careButton];
        
        //        UIButton *deleteButton = [UIButton alloc]initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchUser {
    
}

#pragma mark - 云端请求方法
- (void)queryUserListRequestStart {
    @weakify(self);
    [[self.viewModel.queryUserListCommand execute:self.condition] subscribeNext:^(NSDictionary *returnData) {
        [mainTableView.headRefreshControl endRefreshing];
        [mainTableView reloadData];
    }];
}

#pragma mark - getter&&setter方法
- (DynamicViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[DynamicViewModel alloc] init];
    }
    return _viewModel;
}
@end
