//
//  SexModityViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/13.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "SexModityViewController.h"
#import "MeMainViewModel.h"
#import "Singleton.h"

@interface SexModityViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *tableView;
    UITextField *nickNameTextField;
}

@property (nonatomic, strong) MeMainViewModel *viewModel;

@end

@implementation SexModityViewController

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
    self.title = @"修改性别";
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DEFAULT_HEIGHT) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [nickNameTextField becomeFirstResponder];
    
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 40, 30)];
    tips.text = @"长度限制: 4-24个字";
    tips.textColor = [UIColor lightGrayColor];
    tips.font = [UIFont systemFontOfSize:11.f];
//    [tipsView addSubview:tips];
    return tipsView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"Cell-%ld-%ld",indexPath.section,indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        if (indexPath.row == 0) {
            if ([[Singleton sharedSingleton].sex isEqualToString:@"0"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = @"女";
        } else if (indexPath.row == 1) {
            if ([[Singleton sharedSingleton].sex isEqualToString:@"1"]){
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = @"男";
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [[self.viewModel.updateSexCommand execute:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self)
        if ([returnData[@"result"]isEqualToString:@"successed"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoChanged" object:nil];
            //发送通知
            [self.navigationController popViewControllerAnimated:YES];
        }
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
