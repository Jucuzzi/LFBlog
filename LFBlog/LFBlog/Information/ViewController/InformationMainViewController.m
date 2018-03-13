//
//  InformationMainViewController.m
//  HEMS
//
//  Created by 王力丰 on 2017/9/27.
//  Copyright © 2017年 杭州天丽科技有限公司. All rights reserved.
//

#import "InformationMainViewController.h"
#import "SGPagingView.h"
#import "InformationViewController.h"
#import "PersonalCenterTopView.h"
#import "PersonalCenterTableView.h"
#import "UIView+SGFrame.h"
#import "PYSearch.h"
#import "EditorViewController.h"
#import "BlocksKit+UIKit.h"
//#import "ImageBtn.h"
//#import "HttpUtil.h"
//#import "Singleton.h"
//#import "SignMainViewController.hb"
//#import "ValleyEnergyMainViewController.h"
//#import "SURefreshHeader.h"

#define PersonalCenterVCTopViewHeight [[UIScreen mainScreen]bounds].size.width/2 - 30

@interface InformationMainViewController ()  <UITableViewDelegate, UITableViewDataSource, SGPageTitleViewDelegate, SGPageContentViewDelegate, PersonalCenterChildBaseVCDelegate,UISearchBarDelegate> {
    UISearchBar *customSearchBar;
}
@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;
@property (nonatomic, strong) PersonalCenterTableView *tableView;
@property (nonatomic, strong) PersonalCenterTopView *topView;
@property (nonatomic, strong) UIScrollView *childVCScrollView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) InformationViewController *oneVC;
@property (nonatomic, strong) InformationViewController *twoVC;
@property (nonatomic, strong) InformationViewController *threeVC;
@property (nonatomic, strong) InformationViewController *fourVC;
@property (nonatomic, strong) InformationViewController *fiveVC;
@property (nonatomic, strong) UIImageView *backGroundImage;
@property (nonatomic, strong) NSMutableArray *allVCArr;
@end

@implementation InformationMainViewController

static CGFloat const PersonalCenterVCPageTitleViewHeight = 44;
static CGFloat const PersonalCenterVCNavHeight = NAV_TITLE_HEIGHT;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitle];
    [self initView];
    [self initNotification];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //设置
    [self foundTableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.view addSubview: customSearchBar];
}

-(void)viewWillDisappear:(BOOL)animated {
    [customSearchBar removeFromSuperview];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)initData {
    self.canScroll = YES;
}

- (void)initTitle {
//    self.title = @"资讯";
    
    CGRect mainViewBounds = self.navigationController.view.bounds;
    customSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, CGRectGetMinY(mainViewBounds)+STATUSBAR_HEIGHT +5, SCREEN_WIDTH - 85, 35)];
    customSearchBar.delegate = self;
    customSearchBar.showsCancelButton = NO;
    customSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.navigationController.view addSubview: customSearchBar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"takePhotoIcon"] style:UIBarButtonItemStyleDone target:self action:@selector(publishArticle)];
}

- (void)publishArticle {
    [self.navigationController pushViewController:[[EditorViewController alloc]init] animated:YES];
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeVCScrollState:) name:@"changeVCScrollState" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hemscircleloginOut) name:@"hemscircleloginOut" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshComplete:) name:@"refreshComplete" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshStart:) name:@"refreshStart" object:nil];
}

- (void)refreshStart:(NSNotification *)note{
    NSInteger number = [[note object]integerValue];;
    self.allVCArr[number] = @"0";
}

- (void)refreshComplete:(NSNotification *)note{
    NSInteger number = [[note object]integerValue];;
    self.allVCArr[number] = @"1";
    __block BOOL flag = YES;
    [self.allVCArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"0"]) {
            flag = NO;
        }
    }];
    if (flag == YES) {
//        [self.tableView.header endRefreshing];
    }
}

- (void)hemscircleloginOut {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)changeVCScrollState:(NSNotification *)note {
    self.canScroll = YES;
}


- (void)closeSelf {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)foundTableView {
    CGFloat tableViewX = 0;
    CGFloat tableViewY = 0;
    CGFloat tableViewW = self.view.frame.size.width;
    CGFloat tableViewH = DEFAULT_HEIGHT;
    self.tableView = [[PersonalCenterTableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    _tableView.tableHeaderView = self.topView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.sectionHeaderHeight = PersonalCenterVCPageTitleViewHeight;
    _tableView.rowHeight = self.view.frame.size.height - PersonalCenterVCPageTitleViewHeight;
    _tableView.showsVerticalScrollIndicator = NO;
//    __weak __typeof__(self) weakSelf = self;
//    [self.tableView addRefreshHeaderWithHandle:loadAnimationTypeSuper startWith:^{
//        weakSelf.allVCArr = [[NSMutableArray alloc]initWithArray:@[@"1",@"1",@"1",@"1",@"1"]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInformationMain" object:nil];
////        [weakSelf performSelector:@selector(endRefreshingData) withObject:nil afterDelay:0];
//    }];
    [self.view addSubview:_tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == _tableView) {
        CGFloat offSetY = scrollView.contentOffset.y;
        //滑倒底部
        if (offSetY<0) {
            if (self.canScroll) {
                self.canScroll = NO;
                self.oneVC.vcCanScroll = YES;
                self.oneVC.isTop = NO;
                self.oneVC.isBottom = YES;
                self.twoVC.vcCanScroll =YES;
                self.twoVC.isTop = NO;
                self.twoVC.isBottom = YES;
                self.threeVC.vcCanScroll = YES;
                self.threeVC.isTop = NO;
                self.threeVC.isBottom = YES;
                self.fourVC.vcCanScroll = YES;
                self.fourVC.isTop = NO;
                self.fourVC.isBottom = YES;
                self.fiveVC.vcCanScroll = YES;
                self.fiveVC.isTop = NO;
                self.fiveVC.isBottom = YES;
                scrollView.contentOffset = CGPointMake(0, 0);
            } else {
                scrollView.contentOffset = CGPointMake(0, 0);
            }
            return;
        }
        if (offSetY>=PersonalCenterVCTopViewHeight) {
            //顶部
            if (self.canScroll) {
                self.canScroll = NO;
                self.oneVC.vcCanScroll = YES;
                self.oneVC.isTop = YES;
                self.oneVC.isBottom = NO;
                self.twoVC.vcCanScroll =YES;
                self.twoVC.isTop = YES;
                self.twoVC.isBottom = NO;
                self.threeVC.vcCanScroll = YES;
                self.threeVC.isTop = YES;
                self.threeVC.isBottom = NO;
                self.fourVC.vcCanScroll = YES;
                self.fourVC.isTop = YES;
                self.fourVC.isBottom = NO;
                self.fiveVC.vcCanScroll = YES;
                self.fiveVC.isTop = YES;
                self.fiveVC.isBottom = NO;
                scrollView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
            } else {
                scrollView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
            }
            return;
        }
        if (self.canScroll) {
            self.oneVC.vcCanScroll = NO;
            self.oneVC.isTop = NO;
            self.oneVC.isBottom = NO;
            self.twoVC.vcCanScroll =NO;
            self.twoVC.isTop = NO;
            self.twoVC.isBottom = NO;
            self.threeVC.vcCanScroll = NO;
            self.threeVC.isTop = NO;
            self.threeVC.isBottom = NO;
            self.fourVC.vcCanScroll = NO;
            self.fourVC.isTop = NO;
            self.fourVC.isBottom = NO;
            self.fiveVC.vcCanScroll = NO;
            self.fiveVC.isTop = NO;
            self.fiveVC.isBottom = NO;
        } else {
            if (self.oneVC.isTop) {
                scrollView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
            }else {
                scrollView.contentOffset = CGPointMake(0, 0);
            }
        }
//                scrollView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
//            } else {
//                self.oneVC.vcCanScroll = NO;
//                self.twoVC.vcCanScroll =NO;
//                self.threeVC.vcCanScroll = NO;
//                self.fourVC.vcCanScroll = NO;
//                self.fiveVC.vcCanScroll = NO;
//            }
//            self.canScroll = YES;
        
//        if (!self.canScroll) {
//            scrollView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
//            return;
//        }
        
//        if (self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) {
//            self.tableView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
//        }
//
//        if (offSetY < PersonalCenterVCTopViewHeight) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTitleViewToTop" object:nil];
//        }
    }
}

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView {
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < PersonalCenterVCTopViewHeight) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.contentOffset = CGPointMake(0, PersonalCenterVCTopViewHeight);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentView addSubview:self.pageContentView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.pageTitleView;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (PersonalCenterTopView *)topView {
    if (!_topView) {
        _topView = [[PersonalCenterTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, PersonalCenterVCTopViewHeight)];
//        _backGroundImage = [[UIImageView alloc]initWithFrame:_topView.frame];
//        _backGroundImage.image = [UIImage imageNamed:@"Information_main_background"];
        _topView.backgroundColor = [UIColor whiteColor];
        [_topView addSubview:_backGroundImage];
//        ImageBtn *gotoEnergy = [[ImageBtn alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2-ButtonWidth)/2, PersonalCenterVCTopViewHeight-20-Buttonheight, ButtonWidth, Buttonheight)];
//        [gotoEnergy resetdata:@"绿色谷电" :[UIImage imageNamed:@"Information_main_energy"] :VI_GREEN_COLOR];
//        [gotoEnergy setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [gotoEnergy setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.1f]];
//        [gotoEnergy.layer setCornerRadius:10.f];
//        [gotoEnergy addTarget:self action:@selector(gotoEnergy) forControlEvents:UIControlEventTouchUpInside];
//        [_topView addSubview:gotoEnergy];
//        ImageBtn *gotoSign = [[ImageBtn alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2-ButtonWidth)/2 +SCREEN_WIDTH/2, PersonalCenterVCTopViewHeight-20-Buttonheight, ButtonWidth, Buttonheight)];
//        [gotoSign resetdata:@"积分兑换" :[UIImage imageNamed:@"Information_main_sign"] :VI_RED_COLOR];
//        [gotoSign setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//        [gotoSign.layer setCornerRadius:10.f];
//        [gotoSign addTarget:self action:@selector(gotoSign) forControlEvents:UIControlEventTouchUpInside];
//        [gotoSign setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.1f]];
//        [_topView addSubview:gotoSign];
    }
    return _topView;
}

//-(void) gotoEnergy {
//    ValleyEnergyMainViewController *valleyEnergyView = [[ValleyEnergyMainViewController alloc]init];
//    [self.navigationController pushViewController:valleyEnergyView animated:YES];
//}
//
//- (void)gotoSign {
//    SignMainViewController *signVC = [[SignMainViewController alloc]init];
//    [self.navigationController pushViewController:signVC animated:YES];
//}

- (SGPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        NSArray *titleArr = @[@"官方", @"精品", @"教程", @"娱乐" , @"收藏"];
        /// pageTitleView
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, PersonalCenterVCPageTitleViewHeight) delegate:self titleNames:titleArr];
        _pageTitleView.backgroundColor = [UIColor whiteColor];
        _pageTitleView.titleColorStateNormal = [UIColor blackColor];
        _pageTitleView.titleColorStateSelected = DEFAULT_BLUE_COLOR;
        _pageTitleView.indicatorColor = DEFAULT_BLUE_COLOR;
        _pageTitleView.titleTextScaling = 1.5f;
        _pageTitleView.indicatorLengthStyle = SGIndicatorLengthStyleEqual;
    }
    return _pageTitleView;
}

- (SGPageContentView *)pageContentView {
    if (!_pageContentView) {
        _oneVC = [[InformationViewController alloc] init];
        _oneVC.type = HZCommunityInformationType1;
        _oneVC.delegatePersonalCenterChildBaseVC = self;
        _twoVC = [[InformationViewController alloc] init];
        _twoVC.type = HZCommunityInformationType2;
        _twoVC.delegatePersonalCenterChildBaseVC = self;
        _threeVC = [[InformationViewController alloc] init];
        _threeVC.type = HZCommunityInformationType3;
        _threeVC.delegatePersonalCenterChildBaseVC = self;
        _fourVC = [[InformationViewController alloc] init];
        _fourVC.type = HZCommunityInformationType4;
        _fourVC.delegatePersonalCenterChildBaseVC = self;
        _fiveVC = [[InformationViewController alloc] init];
        _fiveVC.type = HZCommunityInformationType5;
        _fiveVC.delegatePersonalCenterChildBaseVC = self;
        _allVCArr = [[NSMutableArray alloc]initWithArray:@[@"1",@"1",@"1",@"1",@"1"]] ;
        NSArray *childArr = @[_oneVC, _twoVC, _threeVC,_fourVC,_fiveVC];
        /// pageContentView
        CGFloat contentViewHeight = DEFAULT_HEIGHT - PersonalCenterVCNavHeight - PersonalCenterVCPageTitleViewHeight;
        _pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
        _pageContentView.delegatePageContentView = self;
    }
    return _pageContentView;
}



@end
