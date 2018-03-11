//
//  InformationViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationViewModel.h"
#import "InformationDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "KafkaRefresh.h"

@interface InformationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) InformationViewModel *viewModel;
@property (strong,nonatomic) UITableView *mainTable;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    self.isRequesting = NO;
    self.viewModel.type = self.type;
    if (self.type == HZCommunityInformationType5) {
        [self queryCollection];
    } else {
        [self queryInformation];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DEFAULT_HEIGHT -44) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
    [self.mainTable bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                           fillColor:DEFAULT_BLUE_COLOR
                          atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                              self.viewModel.queryTime=@"";
                              self.viewModel.pageNumber = 1;
                              if (self.type == HZCommunityInformationType5) {
                                  [self queryCollection];
                              } else {
                                  [self queryInformation];
                              }
    }];
}

#pragma mark - scrollView 的监听方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainTable) {
        if (!self.vcCanScroll) {
            scrollView.contentOffset = CGPointZero;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.viewModel.infoList count] == 0) {
        return 1;
    } else {
        return [self.viewModel.infoList count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel.infoList count] == 0) {
        return 200;
    } else {
        return 100;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.viewModel.infoList count] == 0) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Information_main_noData"]];
        imageView.frame = CGRectMake(SCREEN_WIDTH/2-50, 50, 100, 100);
        [cell.contentView addSubview:imageView];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *cardView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 90)];
        cardView.layer.cornerRadius = 5;
        cardView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cardView.layer.shadowOpacity = 0.2f;
        cardView.layer.shadowRadius = 3;
        cardView.backgroundColor = [UIColor whiteColor];
        cardView.layer.shadowOffset = CGSizeMake(1,1);
        //放入资讯的缩略图
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.viewModel.infoList[indexPath.row][@"imgPath"]] placeholderImage:nil options:SDWebImageProgressiveDownload];
        [cardView addSubview:imgView];
        //放入资讯的标题
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, SCREEN_WIDTH- 20 - 90 - 10, 20)];
        title.font = [UIFont systemFontOfSize:15.f];
        title.text = self.viewModel.infoList[indexPath.row][@"title"];
        [cardView addSubview:title];
        //放入资讯的详情
        UILabel *briefIntroduction = [[UILabel alloc]initWithFrame:CGRectMake(90, 30, SCREEN_WIDTH- 20 - 90 - 10, 30)];
        briefIntroduction.font = [UIFont systemFontOfSize:11.f];
        briefIntroduction.numberOfLines = 2;
        briefIntroduction.textColor = [UIColor lightGrayColor];
        //string为乱码字符
        briefIntroduction.text = self.viewModel.infoList[indexPath.row][@"briefIntroduction"];
        
        [cardView addSubview:briefIntroduction];
        //放入显示的时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 68, SCREEN_WIDTH- 20 - 90 - 10, 15)];
        NSString *time = self.viewModel.infoList[indexPath.row][@"releaseTime"];
        timeLabel.text = [NSString stringWithFormat:@"%@-%@-%@  %@:%@",[time substringWithRange:NSMakeRange(0, 4)],[time substringWithRange:NSMakeRange(4, 2)],[time substringWithRange:NSMakeRange(6, 2)],[time substringWithRange:NSMakeRange(8, 2)],[time substringWithRange:NSMakeRange(10, 2)]];
        timeLabel.textColor = [UIColor lightGrayColor];
        timeLabel.font = [UIFont systemFontOfSize:11.f];
        [cardView addSubview:timeLabel];
        //放入显示收藏数
        UILabel *thumbLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH- 80, 68, 60, 15)];
        thumbLabel.text = [NSString stringWithFormat:@"%@ 收藏",self.viewModel.infoList[indexPath.row][@"collectNum"]];
        thumbLabel.textAlignment = NSTextAlignmentCenter;
        thumbLabel.textColor = DEFAULT_BLUE_COLOR;
        thumbLabel.font = [UIFont systemFontOfSize:11.f];
        [cardView addSubview:thumbLabel];
        
        [cell.contentView addSubview:cardView];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel.infoList count] != 0) {
        InformationDetailViewController *informationDetail = [[InformationDetailViewController alloc]init];
        informationDetail.informationId = self.viewModel.infoList[indexPath.row][@"informationId"];
        [self.navigationController pushViewController:informationDetail animated:YES];
    }
}


- (void)queryInformation {
    if (!self.isRequesting) {
        self.isRequesting = YES;
        @weakify(self);
        [[self.viewModel.queryInformationCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
            @strongify(self);
            [self.mainTable.headRefreshControl endRefreshing];
            self.isRequesting = NO;
            [self.mainTable reloadData];
        }];
    }
}

- (void)queryCollection {
    if (!self.isRequesting) {
        self.isRequesting = YES;
        @weakify(self);
        [[self.viewModel.queryCollectionCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
            @strongify(self);
            [self.mainTable.headRefreshControl endRefreshing];
            self.isRequesting = NO;
            [self.mainTable reloadData];
        }];
    }
}

- (InformationViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[InformationViewModel alloc] init];
    }
    return _viewModel;
}


@end
