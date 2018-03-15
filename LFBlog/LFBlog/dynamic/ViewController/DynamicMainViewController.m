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
#import "DynamicViewModel.h"
#import "KafkaRefresh.h"
#import "UIImageView+WebCache.h"

#import "HomeTableHeadView.h"
#import "HomeTableCell.h"
#import "NSString+Font.h"
#import "Header.h"
#import "HeadModel.h"
#import "ManyImageView.h"
#define NumberRow 4 //  设置每行显示的图片数量
#define CollClearance 3 //  图片据上下两边的宽度
#define ImageWidthMargin 3  //    图片据左右两边的宽度


@interface DynamicMainViewController ()<UITableViewDelegate,UITableViewDataSource> {
    UITableView *DynamicMainTable;
}
@property (nonatomic, strong) UITableView *homeTable;
@property (nonatomic, strong) NSArray *textArr;
@property (nonatomic, strong) UIView *popView;
@property (nonatomic, strong) UITableView *homeTextView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) int judgeSection;
@property (nonatomic) BOOL judgeBOOL;
@property (nonatomic) BOOL clickBOOL;

@property (nonatomic, strong) DynamicViewModel *viewModel;
@end

@implementation DynamicMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitle];
    [self initView];
    [self initNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initTitle {
    self.title = @"动态";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"publishIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(publishArticle)];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(userIconChanged) name:@"userIconChanged" object:nil];
}

- (void)userIconChanged {
    [DynamicMainTable reloadData];
}

- (void)publishArticle {
}

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    [self queryDynamicRequestStart];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.judgeBOOL = NO;
    self.clickBOOL = YES;
    self.title = @"朋友圈";
    self.dataArr = [NSMutableArray array];
    
//    NSArray *textArr =
//    @[@{@"text":@"中国中医科学院首席研究",@"name":@"老苗",@"time":@"2017-05-12",@"head":@"111",@"image":@[@"111",@"222"]},
//      @{@"text":@"当巴克莱银行外包其结算业务后，新公司的价格更为便宜。",@"name":@"老张",@"time":@"2017-04-19",@"head":@"222",@"image":@[@"111"]},
//      @{@"text":@"存在错误的结算单仍有可能发送出去，但告知我们的客户将不会遭受损失。",@"name":@"老刘",@"time":@"2017-05-05",@"head":@"333",@"image":@[@"222",@"444"]},
//      @{@"text":@"我们公平地结算这笔损坏赔偿账吧。",@"name":@"老王",@"time":@"2017-05-02",@"head":@"444",@"image":@[@"111",@"555",@"666",@"222",@"333"]},
//      @{@"text":@"他们建议，国际交易可以使用评级高的企业票据和债券来进行融资和结算。",@"name":@"老张",@"time":@"2017-05-01",@"head":@"555",@"image":@[@"444",@"666"]},
//      @{@"text":@"他们希望直接与交易所竞争交易和结算业务。",@"name":@"老杨",@"time":@"2017-05-03",@"head":@"666",@"image":@[@"222",@"444",@"555"]}];
    
}

- (void)initView {
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 180 * DISTENCEH)];
    headView.backgroundColor = [UIColor redColor];
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headView.width, headView.height)];
    headImage.image = [UIImage imageNamed:@"headImage"];
    [headView addSubview:headImage];
    
    //创建手势对象
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    self.tap = tap;
    
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    DynamicMainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH , DEFAULT_HEIGHT - 50) style:UITableViewStyleGrouped];
    DynamicMainTable.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    DynamicMainTable.separatorStyle = NO;
    DynamicMainTable.dataSource = self;
    DynamicMainTable.delegate = self;
    [DynamicMainTable bindRefreshStyle:KafkaRefreshStyleReplicatorWoody
                           fillColor:DEFAULT_BLUE_COLOR
                          atPosition:KafkaRefreshPositionHeader refreshHanler:^{
                              self.viewModel.queryTime=@"";
                              self.viewModel.pageNumber = 1;
                              self.viewModel.condition = @"";
                              [self queryDynamicRequestStart];
                          }];
    [self.view addSubview:DynamicMainTable];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArr.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 15;
    } else {
        HeadModel *dataModel = _dataArr[section - 1];
        NSString *text = [NSString stringWithFormat:@"%@",dataModel.detailContent];
        CGFloat height = [text heightWithText:text font:[UIFont systemFontOfSize:11 * DISTENCEW] width:screenWidth - 60 * DISTENCEW - 20];
        NSArray *arr = [dataModel.pictureId componentsSeparatedByString:@","];
        int integer = (int)arr.count / NumberRow;  //整数
        int remainder = arr.count % NumberRow;//   余数
        if (remainder > 0) {
            remainder = 1;
        }
        int imageHeight = (((screenWidth - 70 * DISTENCEW  - 12 - (3 * (NumberRow - 1))) / NumberRow) * (integer + remainder) + (integer + remainder) * 4);
        if (imageHeight > screenHight - NAVGATION_ADD_STATUS_HEIGHT) {
            imageHeight = screenHight - NAVGATION_ADD_STATUS_HEIGHT - 2 * CollClearance;
        }
        if (height > 0) {
            return 75 * DISTENCEW + height + imageHeight +10;
        }else{
            return 92 * DISTENCEH + imageHeight +10;
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else  {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else  {
        return 50 * DISTENCEW;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        HeadModel *dataModel = _dataArr[section -1];
        
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80 * DISTENCEW)];
        mainView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lineLabel = [[UILabel alloc] init];
        lineLabel.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        lineLabel.frame = CGRectMake(15, 0, screenWidth - 30, 1);
        lineLabel.alpha = .5f;
        [mainView addSubview:lineLabel];
        
        
        UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10 * DISTENCEH, 15 * DISTENCEH, 35 * DISTENCEH, 35 * DISTENCEH)];
        [headImage sd_setImageWithURL:[NSURL URLWithString:dataModel.userIconPath] placeholderImage:[UIImage imageNamed:@"user_default"]];
        headImage.layer.cornerRadius = (35 * DISTENCEH/2);
        headImage.layer.masksToBounds = YES;
        [mainView addSubview:headImage];
        
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImage.right + 10 * DISTENCEW, headImage.top, 100 * DISTENCEW, 13 * DISTENCEH)];
        nameLabel.text = [NSString stringWithFormat:@"%@",dataModel.nickName];
        nameLabel.textColor = RGB_COLOR(58, 87, 136);
        nameLabel.font = [UIFont boldSystemFontOfSize:13 * DISTENCEW];
        [mainView addSubview:nameLabel];
        
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.left, nameLabel.bottom + 5 * DISTENCEH, screenWidth - 60 * DISTENCEW - 20, 0)];
        textLabel.text = [NSString stringWithFormat:@"%@",dataModel.detailContent];
        textLabel.font = [UIFont systemFontOfSize:11 * DISTENCEW];
        textLabel.textColor = RGB_COLOR(50, 50, 50);
        textLabel.numberOfLines = 0;
        NSString *text = [NSString stringWithFormat:@"%@",dataModel.detailContent];
        CGFloat height = [text heightWithText:text font:[UIFont systemFontOfSize:11 * DISTENCEW] width:screenWidth - 60 * DISTENCEW - 20];
        textLabel.height = height;
        [mainView addSubview:textLabel];
        
        NSArray *arr = [dataModel.pictureId componentsSeparatedByString:@","];
        int integer = (int)arr.count / NumberRow;  //整数
        int remainder = arr.count % NumberRow;//   余数
        if (remainder > 0) {
            remainder = 1;
        }
        int imageHeight = (((screenWidth - 70 * DISTENCEW  - 12 - (3 * (NumberRow - 1))) / NumberRow) * (integer + remainder) + (integer + remainder) * 4);
        if (imageHeight > screenHight - NAVGATION_ADD_STATUS_HEIGHT) {
            imageHeight = screenHight - NAVGATION_ADD_STATUS_HEIGHT - 2 * CollClearance;
        }
        ManyImageView *imageView = [ManyImageView initWithFrame:CGRectMake(nameLabel.left, textLabel.bottom + 10, screenWidth - 70 * DISTENCEW , imageHeight) imageArr:arr numberRow:NumberRow widthClearance:ImageWidthMargin];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:arr[]] placeholderImage:[[UIImage alloc]init]];
        imageView.backgroundColor = [UIColor whiteColor];
        [mainView addSubview:imageView];
        
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(textLabel.left, imageView.bottom + 8 * DISTENCEH, 120 * DISTENCEW, 11 * DISTENCEH)];
        timeLabel.text = [NSString stringWithFormat:@"%@",dataModel.releaseTiem];
        timeLabel.font = [UIFont systemFontOfSize:11 * DISTENCEW];
        timeLabel.textColor = [UIColor grayColor];
        if (timeLabel.text.length == 0) {
            timeLabel.frame = CGRectMake(textLabel.left, headImage.bottom , 100 * DISTENCEW, 16 * DISTENCEH);
        }
        [mainView addSubview:timeLabel];
        
        
        UIButton *newsBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 40 * DISTENCEW , timeLabel.top - 9 * DISTENCEH, 30 * DISTENCEW, 30 * DISTENCEW)];
        [newsBtn setImage:[UIImage imageNamed:@"弹出"] forState:UIControlStateNormal];
        [newsBtn setImage:[UIImage imageNamed:@"head"] forState:UIControlStateSelected];
        newsBtn.tag = 1000 + section;
        [newsBtn addTarget:self action:@selector(newsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [mainView addSubview:newsBtn];
        
        
        UIView *popView = [[UIView alloc] initWithFrame:CGRectMake(screenWidth - 170 * DISTENCEW, newsBtn.top, 130 * DISTENCEW, 30 * DISTENCEW)];
        popView.backgroundColor = RGB_COLOR(57, 58, 62);
        popView.layer.cornerRadius = 3;
        self.popView = popView;
        if (self.judgeBOOL == YES) {
            int i = _judgeSection - 1000;
            if (i == section) {
                popView.hidden = NO;
            }else{
                popView.hidden = YES;
            }
        }else{
            popView.hidden = YES;
        }
        [mainView addSubview:popView];
        
        UIButton *praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        praiseBtn.backgroundColor = [UIColor clearColor];
        praiseBtn.frame = CGRectMake(0, 0, _popView.width / 2, _popView.height);
        [praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
        [praiseBtn setTitle:@"赞" forState:0];
        praiseBtn.tag = 1000 + section;
        praiseBtn.titleLabel.font = [UIFont systemFontOfSize:11 * DISTENCEW];
        praiseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:praiseBtn];
        
        
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.backgroundColor = [UIColor clearColor];
        commentBtn.frame = CGRectMake(praiseBtn.right, 0, _popView.width / 2, _popView.height);
        [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn setTitle:@"评论" forState:0];
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:11 * DISTENCEW];
        commentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        commentBtn.tag = 1000 + section;
        [popView addSubview:commentBtn];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(praiseBtn.right, 5 * DISTENCEH, 0.6, popView.height - 10 * DISTENCEH)];
        lineView.backgroundColor = RGB_COLOR(120, 120, 120);
        [popView addSubview:lineView];
        
        return mainView;
    }
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
        } else if (indexPath.section == 1) {
            HomeTableCell *cell = [HomeTableCell creatCellWithTableView:tableView];
            return cell;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.judgeBOOL == YES) {
        //        int heght = scrollView.contentOffset.y;
        //        if (heght <= 3 || heght >= -3) {
        [DynamicMainTable removeGestureRecognizer:_tap];
        _judgeBOOL = NO;
        _clickBOOL = YES;
        [DynamicMainTable reloadData];
        //        NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:2];
        //        [self.homeTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        //        }else{
        //
        //        }
    }
}

//  赞
- (void)praiseClick:(UIButton *)sender{
    NSLog(@"这是第几个 %ld",(long)sender.tag - 1000);
    self.judgeBOOL = NO;
    [DynamicMainTable reloadData];
}


//  评论
- (void)commentClick:(UIButton *)sender{
    NSLog(@"评论 %ld",sender.tag - 1000);
    self.judgeBOOL = NO;
    [DynamicMainTable reloadData];
}


//  手势方法
- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSLog(@"点击了手势");
    [DynamicMainTable removeGestureRecognizer:_tap];
    //    [_tap removeTarget:self action:@selector(tapAction:)];
    if (self.judgeBOOL == YES) {
        _clickBOOL = YES;
        self.judgeBOOL = NO;
        [DynamicMainTable reloadData];
    }
}


- (void)newsBtnClick:(UIButton *)sender{
    
    if (_clickBOOL) {
        self.judgeBOOL = YES;
        self.judgeSection = (int)sender.tag;
        [DynamicMainTable reloadData];
        if (self.judgeBOOL == YES) {
            [DynamicMainTable reloadData];
        }
        [DynamicMainTable addGestureRecognizer:_tap];
    }else{
        if (self.judgeBOOL == YES) {
            [_tap removeTarget:self action:@selector(tapAction:)];
            self.judgeBOOL = NO;
            [DynamicMainTable reloadData];
        }
    }
    _clickBOOL = !_clickBOOL;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@",,,,,,,,");
}

- (void)queryDynamicRequestStart {
    @weakify(self);
    [[self.viewModel.queryDynamicCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        [self.dataArr removeAllObjects];
        for (NSDictionary *dic in returnData[@"infoList"]) {
            [self.dataArr addObject:[HeadModel modelWithDict:dic]];
        }
        [DynamicMainTable reloadData];
        [DynamicMainTable.headRefreshControl endRefreshing];
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
