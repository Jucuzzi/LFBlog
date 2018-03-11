//
//  AddDynamicViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/8.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "AddDynamicViewController.h"
#import "UIImage+Extension.h"

@interface AddDynamicViewController ()<UITextViewDelegate>{
    UIView *buttomView;
    UITextView *dynamicContent;
//    UITextField *commentView;
}

@property (nonatomic, assign) BOOL isKeyboardUped;

@end

@implementation AddDynamicViewController

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
    
}

- (void)initNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initTitle {
    self.title = @"发布新动态";
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    dynamicContent = [[UITextView alloc]initWithFrame:CGRectMake(20, 20 , SCREEN_WIDTH - 40, 40)];
    [self.view addSubview:dynamicContent];
    dynamicContent.textColor = [UIColor lightGrayColor];
    dynamicContent.delegate = self;
    dynamicContent.font = [UIFont systemFontOfSize:17.f];
    dynamicContent.text = @"分享点好东西...";
    
    //放入底部进行评论的文本输入框
    buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, DEFAULT_HEIGHT - 60, SCREEN_WIDTH, 60)];
    buttomView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [buttomView addSubview:lineView];
//    commentView = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 20-80, 40)];
//    commentView.layer.borderColor = DEFAULT_BLUE_COLOR.CGColor;
//    commentView.layer.borderWidth = 1;
//    [buttomView addSubview:commentView];
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(25, 7.5, 45, 45)];
    [photoButton setImage:[[UIImage imageNamed:@"photoIcon"] imageWithColor:DEFAULT_BLUE_COLOR] forState:UIControlStateNormal];
    [buttomView addSubview:photoButton];
    
    UIButton *connectButton = [[UIButton alloc]initWithFrame:CGRectMake(85, 7.5, 45, 45)];
    [connectButton setImage:[[UIImage imageNamed:@"connectIcon"] imageWithColor:DEFAULT_BLUE_COLOR] forState:UIControlStateNormal];
    [buttomView addSubview:connectButton];
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30-80, 10, 80, 40)];
    [submitButton setTitle:@"发布" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [submitButton setBackgroundImage:[UIImage imageFromColor:DEFAULT_BLUE_COLOR size:CGSizeMake(80, 40)] forState:UIControlStateNormal];
    submitButton.layer.borderColor = DEFAULT_BLUE_COLOR.CGColor;
    submitButton.layer.cornerRadius = 20.f;
    submitButton.layer.masksToBounds = YES;
    submitButton.layer.borderWidth = 1;
    [submitButton addTarget:self action:@selector(addCommentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:submitButton];
    [self.view addSubview:buttomView];
}

#pragma mark - 逻辑处理方法
- (void)addCommentBtnClicked {
    [dynamicContent resignFirstResponder];
//    [self addComment];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat transformY = height;
    CGRect frame = buttomView.frame;
    frame.origin.y = transformY - 60 -STATUSBAR_HEIGHT - NAV_TITLE_HEIGHT;
    buttomView.frame = frame;
    _isKeyboardUped = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = buttomView.frame;
    frame.origin.y =  DEFAULT_HEIGHT - 60;
    buttomView.frame = frame;
    _isKeyboardUped = NO;
}

#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [dynamicContent resignFirstResponder];
    return YES;
}

@end
