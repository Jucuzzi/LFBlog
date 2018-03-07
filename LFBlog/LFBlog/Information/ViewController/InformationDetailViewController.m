//
//  InformationDetailViewController.m
//  HEMS
//
//  Created by 王力丰 on 2017/10/31.
//  Copyright © 2017年 杭州天丽科技有限公司. All rights reserved.
//

#import "InformationDetailViewController.h"
#import "InformationViewModel.h"
//#import "CommentDetailViewController.h"
//#import "MBProgressHUD.h"

@interface InformationDetailViewController ()

@property(nonatomic,strong) InformationViewModel *viewModel;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UILabel *collectLabel;

@end

@implementation InformationDetailViewController

#pragma mark - 生命周期方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    [self initTitle];
    
}

-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化方法

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    self.viewModel.selectedInformationId = self.informationId;
    [self queryInformationById];
}

- (void)initTitle {
    self.title = @"资讯详情";
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    /************************************  标题label  ************************************/
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20 + NAV_TITLE_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH - 40, 50)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.text = self.viewModel.infoDetailData[@"title"];
    [self.view addSubview:titleLabel];
    /************************************  来源label  ************************************/
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80+ NAV_TITLE_HEIGHT + STATUSBAR_HEIGHT, 120, 20)];
    authorLabel.font = [UIFont systemFontOfSize:13.f];
    authorLabel.textAlignment = NSTextAlignmentLeft;
    authorLabel.text = [NSString stringWithFormat:@"作者:%@",self.viewModel.infoDetailData[@"author"]];
    authorLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:authorLabel];
    
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(145,80+ NAV_TITLE_HEIGHT + STATUSBAR_HEIGHT, 120, 20)];
    sourceLabel.font = [UIFont systemFontOfSize:13.f];
    sourceLabel.textAlignment = NSTextAlignmentLeft;
    sourceLabel.text = [NSString stringWithFormat:@"来源:%@",self.viewModel.infoDetailData[@"source"]];
    sourceLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:sourceLabel];
    /************************************  时间label  ************************************/
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 80+ NAV_TITLE_HEIGHT + STATUSBAR_HEIGHT, 80, 20)];
    timeLabel.font = [UIFont systemFontOfSize:13.f];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.text = [NSString stringWithFormat:@"%@-%@ %@:%@",[self.viewModel.infoDetailData[@"releaseTime"] substringWithRange:NSMakeRange(4, 2)],[self.viewModel.infoDetailData[@"releaseTime"]substringWithRange:NSMakeRange(6, 2)],[self.viewModel.infoDetailData[@"releaseTime"]substringWithRange:NSMakeRange(8, 2)],[self.viewModel.infoDetailData[@"releaseTime"]substringWithRange:NSMakeRange(10, 2)]] ;
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:timeLabel];
    /************************************  中间的详细文本  ************************************/
    NSString *strHTML = self.viewModel.infoDetailData[@"detailContent"];
    
    strHTML = [strHTML stringByReplacingOccurrencesOfString:@"<img" withString:@"<br><img width='80%' style='padding-left:10%;padding-top:10px;padding-bottom:10px;'"];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 110+ NAV_TITLE_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH, DEFAULT_HEIGHT - 170)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    
    NSString * javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
                  viewPortTag.id='viewport';  \
                  viewPortTag.name = 'viewport';  \
                  viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;';  \
                  document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int)webView.bounds.size.width];
    
    [webView stringByEvaluatingJavaScriptFromString:javascript];
    
    [webView loadHTMLString:strHTML baseURL:nil];
    
//    NSString *sourceString = [[NSString alloc] initWithCString:[self.returnDic[@"source"] cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
//    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[sourceString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    UILabel * htmlLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH -40, DEFAULT_HEIGHT - 100 - 60)];
//    htmlLabel.numberOfLines = 0;
//    htmlLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    htmlLabel.attributedText = attrStr;
//    [self.view addSubview:htmlLabel];
//    [htmlLabel sizeToFit];
//    [htmlLabel setContentMode:UIViewContentModeTop];
    /************************************  底部的操作栏  ************************************/
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEFAULT_HEIGHT-60 + NAV_TITLE_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH, 130)];
    buttomView.backgroundColor = [UIColor colorWithRed:250/255.f green:250/255.f blue:250/255.f alpha:1];
    //左边的喜欢按钮
    _likeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"Information_detail_noheart"] forState:UIControlStateNormal];
    _likeBtn.backgroundColor = [UIColor clearColor];
    [_likeBtn addTarget:self action:@selector(collect) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:_likeBtn];
    //按钮右上角的收藏量
    _collectLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, 50, 15)];
    _collectLabel.textColor = [UIColor lightGrayColor];
    _collectLabel.text = self.viewModel.collectNum;
    _collectLabel.textAlignment = NSTextAlignmentLeft;
    _collectLabel.font = [UIFont systemFontOfSize:11.f];
//    [buttomView addSubview:_collectLabel];
    //收藏文本
    UILabel *favorite = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 100, 20)];
    favorite.textColor = [UIColor lightGrayColor];
    favorite.text = @"收藏";
    [buttomView addSubview:favorite];
    //右边的参与讨论按钮
    UIButton *commentView = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 150, 10, 130, 40)];
    commentView.backgroundColor = DEFAULT_BLUE_COLOR;
    commentView.layer.cornerRadius = 20;
    [commentView addTarget:self action:@selector(gotoComment) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 10, 24, 24)];
    iconImage.image = [UIImage imageNamed:@"Information_detail_message"];
    [commentView addSubview:iconImage];
    UILabel *commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 7, 40, 15)];
    CGSize size = CGSizeMake(1000, 1000);
    CGRect rect = [self.viewModel.commentNum boundingRectWithSize:size options:nil attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f]} context:nil];
    commentNumLabel.font = [UIFont systemFontOfSize:11.f];
    commentNumLabel.textColor = [UIColor whiteColor];
    commentNumLabel.textAlignment = NSTextAlignmentCenter;
    commentNumLabel.backgroundColor = [UIColor redColor];
    commentNumLabel.layer.cornerRadius = 7.5f;
    commentNumLabel.layer.masksToBounds= YES;
    commentNumLabel.text = self.viewModel.commentNum;
    commentNumLabel.frame = CGRectMake(35,2, rect.size.width+10, rect.size.height);
    [commentView addSubview:commentNumLabel];
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 80, 20)];
    commentLabel.text = @"参与讨论";
    commentLabel.textColor = [UIColor whiteColor];
    commentLabel.font = [UIFont systemFontOfSize:15.f];
    [commentView addSubview:commentLabel];
    
    [buttomView addSubview:commentView];
    [self.view addSubview:buttomView];
}

#pragma mark - 逻辑处理方法

- (void)collect {
    NSLog(@"%@",self.viewModel.isCollect);
    if([self.viewModel.isCollect isEqualToString:@"0"]) {
        [self addCollectionById];
    } else {
        [self deleteCollectionById];
    }
}

- (void)gotoComment {
//    CommentDetailViewController *commentVC = [[CommentDetailViewController alloc]init];
//    commentVC.informationId = self.informationId;
//    [self.navigationController pushViewController:commentVC animated:YES];
}


#pragma mark - 云端请求方法
- (void)queryInformationById {
    @weakify(self);
    [[self.viewModel.queryInformationDetailCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        [self queryCollectionById];
    }];
}

- (void)queryCollectionById {
    @weakify(self);
    [[self.viewModel.queryInformationCollectionCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        [self initView];
        if ([self.viewModel.isCollect isEqualToString:@"0"]) {
            [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Information_detail_noheart"] forState:UIControlStateNormal];
        } else {
            [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Information_detail_heart"] forState:UIControlStateNormal];
        }
    }];
}

- (void)addCollectionById {
    @weakify(self);
    [[self.viewModel.addToCollectionCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Information_detail_heart"] forState:UIControlStateNormal];
        self.collectLabel.text = [NSString stringWithFormat:@"%d",self.viewModel.collectNum.intValue +1];
    }];
}

- (void)deleteCollectionById {
    @weakify(self);
    [[self.viewModel.deleteFromCollectionCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        [self.likeBtn setBackgroundImage:[UIImage imageNamed:@"Information_detail_noheart"] forState:UIControlStateNormal];
        self.collectLabel.text = [NSString stringWithFormat:@"%d",self.viewModel.collectNum.intValue - 1];
    }];
}


- (InformationViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[InformationViewModel alloc] init];
    }
    return _viewModel;
}

@end
