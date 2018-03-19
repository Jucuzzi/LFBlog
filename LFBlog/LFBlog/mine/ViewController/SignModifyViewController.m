//
//  SignModifyViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/15.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "SignModifyViewController.h"
#import "MeMainViewModel.h"
#import "Singleton.h"

@interface SignModifyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    UITableView *tableView;
    UITextView *signTextView;
}

@property (nonatomic, strong) MeMainViewModel *viewModel;

@end

@implementation SignModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initTitle];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [signTextView becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated {
    [signTextView resignFirstResponder];
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
    self.title = @"个性签名";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveSign)];
}

- (void)initView {
    self.view.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, DEFAULT_HEIGHT) style:UITableViewStyleGrouped];
    tableView.separatorStyle = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
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
        signTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, SCREEN_WIDTH, 110)];
        signTextView.font = [UIFont systemFontOfSize:17.f];
        signTextView.text = [Singleton sharedSingleton].sign;
        signTextView.delegate = self;
        
//        self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 180, self.textView.frame.size.height + 110, 150, 50)];
//        self.tipLabel.backgroundColor = [UIColor clearColor];
//        self.tipLabel.font = [UIFont systemFontOfSize:12];
//        self.tipLabel.text = [NSString stringWithFormat:@"字数不少于%d个字", MINVALUE];
//        self.tipLabel.textAlignment = NSTextAlignmentRight;
//        [self.view addSubview:self.tipLabel];
        
        [cell.contentView addSubview:signTextView];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
//        [self.textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSUInteger count = textView.text.length;
//    if (MINVALUE > 0 && count < MINVALUE) {
//        self.tipLabel.text = [NSString stringWithFormat:@"字数不少于%d个字", MINVALUE];
//    } else {
//        self.tipLabel.text = [NSString stringWithFormat:@"%ld/%ld字", (unsigned long)count, (long)MAXVALUE];
//    }
}

- (void)saveSign {
    @weakify(self);
    [[self.viewModel.updateSignCommand execute:signTextView.text] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self);
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
