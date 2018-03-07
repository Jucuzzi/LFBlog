//
//  CommentDetailViewController.m
//  HEMS
//
//  Created by 王力丰 on 2017/11/6.
//  Copyright © 2017年 杭州天丽科技有限公司. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "CommentDetailTableViewCell.h"
#import "InformationViewModel.h"
#import "UIImageView+WebCache.h"

@interface CommentDetailViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CommentDetailTableViewCellDelegate>{
    UIView *buttomView;
    UITextField *commentView;
    
}
@property (nonatomic, strong) InformationViewModel *viewModel;

@property (nonatomic, strong) NSDictionary *returnDic;
@property (nonatomic, strong) NSMutableArray *commentArr;
@property (nonatomic, assign) BOOL isKeyboardUped;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isReply;
@property (nonatomic, strong) NSArray *reportTypeArr;
@property (nonatomic, strong) NSString *queryTime;

@property (nonatomic, strong) NSString *currentPage;
/**
 *    @brief    上拉刷新视图
 */
@property(nonatomic,assign)    bool     reloading;

@end

@implementation CommentDetailViewController

#pragma mark - 生命周期方法

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitle];
    [self initView];
    [self initNotification];
}

-(void)viewWillAppear:(BOOL)animated {
    [self initNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化方法
- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
     _isReply = NO;
    _commentArr = [[NSMutableArray alloc]init];
    _currentPage = @"1";
    [self getCommentByPage:_currentPage];
}

- (void)initTitle {
    self.title = @"评论";
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //放入中间的展示评论的列表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT + NAV_TITLE_HEIGHT, SCREEN_WIDTH, DEFAULT_HEIGHT-50) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    //放入底部进行评论的文本输入框
    buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEFAULT_HEIGHT + STATUSBAR_HEIGHT + NAV_TITLE_HEIGHT - 50, SCREEN_WIDTH, 50)];
    buttomView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [buttomView addSubview:lineView];
    commentView = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20-80, 40)];
    commentView.layer.borderColor = DEFAULT_BLUE_COLOR.CGColor;
    commentView.layer.borderWidth = 1;
    commentView.delegate = self;
    [buttomView addSubview:commentView];
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-80, 5, 80, 40)];
    [submitButton setTitle:@"发送" forState:UIControlStateNormal];
    [submitButton setBackgroundColor:DEFAULT_BLUE_COLOR];
    submitButton.layer.borderColor = DEFAULT_BLUE_COLOR.CGColor;
    submitButton.layer.borderWidth = 1;
    [submitButton addTarget:self action:@selector(addCommentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:submitButton];
    [self.view addSubview:buttomView];
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 逻辑处理方法
- (void)addCommentBtnClicked {
    [commentView resignFirstResponder];
    [self addComment];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat transformY = height;
    CGRect frame = buttomView.frame;
    frame.origin.y = transformY - 50;
    buttomView.frame = frame;
    _isKeyboardUped = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = buttomView.frame;
    frame.origin.y =  DEFAULT_HEIGHT + STATUSBAR_HEIGHT + NAV_TITLE_HEIGHT - 50;
    buttomView.frame = frame;
    _isKeyboardUped = NO;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CommentDetailTableViewCellDelegate

-(void)thumbAction:(BOOL)thumbState andCommentId:(NSString *)commentId {
    [self thumbWithThumbState:thumbState andCommentId:(NSString *)commentId];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_commentArr count] == 0) {
        return 1;
    } else {
        return [_commentArr count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_commentArr count] == 0) {
        return 200;
    } else {
        NSString *commentText = _commentArr[indexPath.row][@"commentDetail"];
        CGRect labelRect = [commentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.f]} context:nil];
        return labelRect.size.height + 80;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (cell == nil) {
    if ([_commentArr count] != 0) {
        CommentDetailTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row]];
        cell = [[CommentDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        NSDictionary *cellData = _commentArr[indexPath.row];
//        NSLog(@"%@",cellData);
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:cellData[@"imgPath"]] placeholderImage:[UIImage imageNamed:@"User_blue_default_userPhoto"]];
        @try {
            if (![cellData[@"name"] isKindOfClass:[NSNull class]]) {
                cell.accountLabel.text = cellData[@"name"];
            }
        } @catch (NSException *exception) {
//            NSLog(@"%@",exception);
        } @finally {
            
        }
        cell.commentId = cellData[@"commentId"];
        cell.timeLabel.text = cellData[@"commentTime"];
        NSLog(@"%@",cellData[@"preferenceCount"]);
//        if (cellData[@"preferenceCount"]!=nil) {
//            cell.thumbNum.text = cellData[@"preferenceCount"];
//        } else {
            cell.thumbNum.text = [NSString stringWithFormat:@"%@",cellData[@"preferenceCount"]];
//        }
        
        if ([cellData[@"isThumbed"] isEqualToString:@"0"]) {
            [cell.thumbIcon setImage:[UIImage imageNamed:@"cancelThumbsUp"] forState:UIControlStateNormal];
            cell.thumbState = NO;
        } else {
            [cell.thumbIcon setImage:[UIImage imageNamed:@"thumbsUp"] forState:UIControlStateNormal];
            cell.thumbState = YES;
        }
        NSString *commentText = cellData[@"commentDetail"];
        [cell setCommmentDetailWithText:commentText];
        CGRect labelRect = [commentText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 90, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.f]} context:nil];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, labelRect.size.height + 80 - 0.5, SCREEN_WIDTH - 10, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lineView];
        return cell;
    } else {
        UITableViewCell *cell;
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *noInfoTip = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        noInfoTip.image = [UIImage imageNamed:@"history_empty"];
        noInfoTip.center = CGPointMake(SCREEN_WIDTH / 2, 60);
        [cell.contentView addSubview:noInfoTip];
        UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, SCREEN_WIDTH, 30)];
        noDataLabel.text = @"还没有记录哦";
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        noDataLabel.font = [UIFont systemFontOfSize:15.f];
        noDataLabel.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:noDataLabel];
        return cell;
    }
    
//    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[NSString stringWithFormat:@"%@",_commentArr[indexPath.row][@"isSelf"]] isEqualToString:@"1"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
        __weak __typeof__(self) weakSelf = self;
        UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (nil == _commentArr[indexPath.row][@"name"]) {
                commentView.placeholder = @"@NULL:";
            } else {
                commentView.placeholder = [NSString stringWithFormat:@"@%@:",[[NSString alloc] initWithCString:[_commentArr[indexPath.row][@"name"] cStringUsingEncoding:NSISOLatin1StringEncoding]encoding:NSUTF8StringEncoding]];
            }
            weakSelf.isReply = YES;
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf deleteCommentByCommentId:_commentArr[indexPath.row][@"commentId"]];
        }];
        [alert addAction:replyAction];
        [alert addAction:deleteAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
        __weak __typeof__(self) weakSelf = self;
        UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (nil == _commentArr[indexPath.row][@"name"]) {
                commentView.placeholder = @"@NULL:";
            } else {
                commentView.placeholder = [NSString stringWithFormat:@"@%@:",[[NSString alloc] initWithCString:[_commentArr[indexPath.row][@"name"] cStringUsingEncoding:NSISOLatin1StringEncoding]encoding:NSUTF8StringEncoding]];
            }
            weakSelf.isReply = YES;
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *reportActionController = [UIAlertController alertControllerWithTitle:@"请选择举报类型" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
            [_reportTypeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *reportType = [[NSString alloc]initWithCString:[obj[@"reportValue"] cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
                UIAlertAction *reportAction = [UIAlertAction actionWithTitle:reportType style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf reportCommentByCommentId:_commentArr[indexPath.row][@"commentId"] reportId:_reportTypeArr[idx][@"reportId"]];
                }];
                [reportActionController addAction:reportAction];
            }];
            [self presentViewController:reportActionController animated:YES completion:nil];
        }];
        [alert addAction:replyAction];
        [alert addAction:deleteAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 云端请求方法
//获取评论的table的数据
- (void)getCommentByPage:(NSString *)page{
    self.viewModel.commentPageNumber = page;
    self.viewModel.selectedInformationId = self.informationId;
    @weakify(self);
    [[self.viewModel.queryCommentCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        NSLog(@"删除的结果是%@",returnData);
        self.reportTypeArr = returnData[@"reportTypeList"];
        self.commentArr = [[NSMutableArray alloc]initWithCapacity:1];
        self.commentArr = returnData[@"result"];
        [self.tableView reloadData];
    }];
}

//发表评论
- (void)addComment {
    self.viewModel.selectedInformationId = self.informationId;
    if ([commentView.text length] == 0) {
//        [MBProgressHUDUtil alertToView:self.view message:@"请输入评论内容"];
        return;
    }
    if (!self.isReply) {
        self.viewModel.commentDetail = commentView.text;
    } else {
        NSString *replayText = [NSString stringWithFormat:@"%@%@",commentView.placeholder,commentView.text];
        self.viewModel.commentDetail = replayText;
    }
    @weakify(self);
    [[self.viewModel.addCommentCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        NSLog(@"删除的结果是%@",returnData);
        commentView.text = @"";
        self.currentPage = @"1";
        self.commentArr = [[NSMutableArray alloc]init];
        [self getCommentByPage:@"1"];
    }];
}

//赞或取消赞
- (void)thumbWithThumbState:(BOOL)thumbState andCommentId:(NSString *)commentId {
    self.viewModel.commentId = commentId;
    self.viewModel.thumbState = thumbState;
    @weakify(self);
    [[self.viewModel.thumbOrNotCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        NSLog(@"删除的结果是%@",returnData);
        self.currentPage = @"1";
        self.commentArr = [[NSMutableArray alloc]init];
        [self getCommentByPage:@"1"];
    }];
}

//删除这条自己发布的评论
- (void)deleteCommentByCommentId:(NSString *)commentId {
    self.viewModel.commentId = commentId;
    @weakify(self);
    [[self.viewModel.deleteCommentCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        NSLog(@"删除的结果是%@",returnData);
        self.currentPage = @"1";
        self.commentArr = [[NSMutableArray alloc]init];
        [self getCommentByPage:@"1"];
    }];
}

//举报别人发布的评论
- (void)reportCommentByCommentId:(NSString *)commentId reportId:(NSString *)reportId{
    self.viewModel.commentId = commentId;
    self.viewModel.reportType = reportId;
    @weakify(self);
    [[self.viewModel.reportCommentCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
        NSLog(@"举报的结果是%@",returnData);
    }];
}


- (InformationViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[InformationViewModel alloc] init];
    }
    return _viewModel;
}



@end
