//
//  LoginViewController.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "ReactiveObjC.h"
#import "Masonry.h"
#import "UIImage+Extension.h"

@interface LoginViewController ()<UITableViewDelegate, UITableViewDataSource>{
    UITableView *loginView;
    UITextField *accountText;
    UITextField *passwordText;
    UITextField *validateText;
    BOOL        cansee;
    //登录，忘记密码，注册三合一按钮
    UIButton *login;
    //获取验证码按钮
    UIButton *getValidate;
}

@property(nonatomic,strong) LoginViewModel *viewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)initData {
    // 调用viewModel的bindComplete方法确保viewModel初始化完成
    [self.viewModel bindComplete];
    
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *close = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20 + 20, 15, 15)];
    [close setImage:[UIImage imageNamed:@"close"]];
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 55, 55)];
    [closeButton setBackgroundColor: [UIColor clearColor]];
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:close];
    [self.view addSubview:closeButton];
    
    // 顶上的textlogo
    UIImageView *textLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:textLogo];
    [textLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(100);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    // 放入帐号和密码输入的表格
    loginView = [[UITableView alloc]initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, 130) style:UITableViewStylePlain];
    loginView.delegate = self;
    loginView.dataSource = self;
    loginView.scrollEnabled = NO;
    loginView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.view addSubview:loginView];
    
    // 登录按钮
    login = [[UIButton alloc]initWithFrame:CGRectMake(30, 365 + 60, SCREEN_WIDTH - 60, 45)];
    login.backgroundColor = DEFAULT_BLUE_COLOR;
    login.layer.masksToBounds = YES;
    login.layer.cornerRadius = 5;
    login.enabled = YES;
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [login setTitle:@"登  录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:login];
    
    // 忘记密码和注册帐号
    UIButton *forget = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 - 95, 430 + 60, 80, 30)];
    forget.backgroundColor = [UIColor clearColor];
    forget.layer.masksToBounds = YES;
    forget.layer.cornerRadius = 5;
    forget.enabled = YES;
    [forget addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];
    [forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    forget.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [forget setTitleColor:DEFAULT_BLUE_COLOR forState:UIControlStateNormal];
    [self.view addSubview:forget];
    
    UIButton *loginButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2 - 40, 430 + 60, 80, 30)];
    loginButton.backgroundColor = [UIColor clearColor];
    loginButton.layer.masksToBounds = YES;
    loginButton.layer.cornerRadius = 5;
    loginButton.enabled = YES;
    [loginButton addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setTitle:@"登录账户" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [loginButton setTitleColor:DEFAULT_BLUE_COLOR forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    
    UIButton *reg = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2 / 3 + 15, 430 + 60, 80, 30)];
    reg.backgroundColor = [UIColor clearColor];
    reg.layer.masksToBounds = YES;
    reg.layer.cornerRadius = 5;
    reg.enabled = YES;
    [reg addTarget:self action:@selector(reg) forControlEvents:UIControlEventTouchUpInside];
    [reg setTitle:@"注册账户" forState:UIControlStateNormal];
    reg.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [reg setTitleColor:DEFAULT_BLUE_COLOR forState:UIControlStateNormal];
    [self.view addSubview:reg];
    
    // 中间分割线
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = CGRectMake(SCREEN_WIDTH / 3, 433 + 60, .5, 25);
    lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    lineLayer.opacity = .5;
    [self.view.layer addSublayer:lineLayer];
    
    // 中间分割线
    CALayer *lineLayer2 = [CALayer layer];
    lineLayer2.frame = CGRectMake(SCREEN_WIDTH * 2 / 3, 433 + 60, .5, 25);
    lineLayer2.backgroundColor = [UIColor lightGrayColor].CGColor;
    lineLayer2.opacity = .5;
    [self.view.layer addSublayer:lineLayer2];
    
}

#pragma mark - UITableViewDelegate&UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.type == LFBlogTypeLogin) {
        if (indexPath.row == 0) {
            UIImageView *account = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"account"]imageWithColor:[UIColor lightGrayColor]]];
            account.frame = CGRectMake(30, 20, 20, 20);
            accountText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            accountText.placeholder = @"手机号";
            accountText.font = [UIFont systemFontOfSize:15.f];
            [cell.contentView addSubview:account];
            [cell.contentView addSubview:accountText];
        } else if (indexPath.row == 1) {
            UIImageView *passoword = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"password"]imageWithColor:[UIColor lightGrayColor]]];
            passoword.frame = CGRectMake(30, 20, 20, 20);
            passwordText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            passwordText.placeholder = @"密码";
            passwordText.font = [UIFont systemFontOfSize:15.f];
            UIButton *canSee = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 15, 30, 30)];
            [canSee addTarget:self action:@selector(changePasswordState:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:canSee];
            [canSee setImage:[[UIImage imageNamed:@"cannotsee"]imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            passwordText.secureTextEntry = YES;
            [cell.contentView addSubview:passoword];
            [cell.contentView addSubview:passwordText];
        }
    } else if (self.type == LFBlogTypeRegister) {
        if (indexPath.row == 0) {
            UIImageView *account = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"account"]imageWithColor:[UIColor lightGrayColor]]];
            account.frame = CGRectMake(30, 20, 20, 20);
            
            accountText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            accountText.placeholder = @"手机号";
            accountText.font = [UIFont systemFontOfSize:15.f];
            
            [cell.contentView addSubview:account];
            [cell.contentView addSubview:accountText];
        } else if (indexPath.row == 1) {
            UIImageView *validateImage = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"validate"]imageWithColor:[UIColor lightGrayColor]]];
            validateImage.frame = CGRectMake(30, 20, 20, 20);
            //输入验证码文本
            validateText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            validateText.placeholder = @"验证码";
            validateText.font = [UIFont systemFontOfSize:15.f];
            //放入获取验证码按钮
            getValidate = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 15, 100, 30)];
            [getValidate setBackgroundColor: DEFAULT_BLUE_COLOR];
            [getValidate setTitle:@"获取验证码" forState:UIControlStateNormal];
            getValidate.titleLabel.font = [UIFont systemFontOfSize:15.f];
            getValidate.layer.cornerRadius = 10.f;
            getValidate.layer.masksToBounds = YES;
            [getValidate addTarget:self action:@selector(getValidate:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:getValidate];
            //            [canSee setImage:[[UIImage imageNamed:@"cannotsee"]imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            passwordText.secureTextEntry = YES;
            [cell.contentView addSubview:validateImage];
            [cell.contentView addSubview:validateText];
        } else if (indexPath.row == 2) {
            UIImageView *passoword = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"password"]imageWithColor:[UIColor lightGrayColor]]];
            passoword.frame = CGRectMake(30, 20, 20, 20);
            
            passwordText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            passwordText.placeholder = @"密码";
            passwordText.font = [UIFont systemFontOfSize:15.f];
            
            UIButton *canSee = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 15, 30, 30)];
            
            [canSee addTarget:self action:@selector(changePasswordState:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:canSee];
            [canSee setImage:[[UIImage imageNamed:@"cannotsee"]imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            passwordText.secureTextEntry = YES;
            [cell.contentView addSubview:passoword];
            [cell.contentView addSubview:passwordText];
        }
    } else if (self.type == LFBlogTypeForget) {
        if (indexPath.row == 0) {
            UIImageView *account = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"account"]imageWithColor:[UIColor lightGrayColor]]];
            account.frame = CGRectMake(30, 20, 20, 20);
            
            accountText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            accountText.placeholder = @"手机号";
            accountText.font = [UIFont systemFontOfSize:15.f];
            
            [cell.contentView addSubview:account];
            [cell.contentView addSubview:accountText];
        } else if (indexPath.row == 1) {
            UIImageView *validateImage = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"validate"]imageWithColor:[UIColor lightGrayColor]]];
            validateImage.frame = CGRectMake(30, 20, 20, 20);
            //输入验证码文本
            validateText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            validateText.placeholder = @"验证码";
            validateText.font = [UIFont systemFontOfSize:15.f];
            //放入获取验证码按钮
            getValidate = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 130, 15, 100, 30)];
            [getValidate setBackgroundColor: DEFAULT_BLUE_COLOR];
            [getValidate setTitle:@"获取验证码" forState:UIControlStateNormal];
            getValidate.titleLabel.font = [UIFont systemFontOfSize:15.f];
            getValidate.layer.cornerRadius = 10.f;
            getValidate.layer.masksToBounds = YES;
            [getValidate addTarget:self action:@selector(getValidate:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:getValidate];
            //            [canSee setImage:[[UIImage imageNamed:@"cannotsee"]imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            passwordText.secureTextEntry = YES;
            [cell.contentView addSubview:validateImage];
            [cell.contentView addSubview:validateText];
        } else if (indexPath.row == 2) {
            UIImageView *passoword = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"password"]imageWithColor:[UIColor lightGrayColor]]];
            passoword.frame = CGRectMake(30, 20, 20, 20);
            
            passwordText = [[UITextField alloc]initWithFrame:CGRectMake(60, 20, SCREEN_WIDTH - 130, 20)];
            passwordText.placeholder = @"密码";
            passwordText.font = [UIFont systemFontOfSize:15.f];
            
            UIButton *canSee = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, 15, 30, 30)];
            
            [canSee addTarget:self action:@selector(changePasswordState:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:canSee];
            [canSee setImage:[[UIImage imageNamed:@"cannotsee"]imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
            passwordText.secureTextEntry = YES;
            [cell.contentView addSubview:passoword];
            [cell.contentView addSubview:passwordText];
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == LFBlogTypeLogin) {
        return 2;
    } else if (self.type == LFBlogTypeForget || self.type == LFBlogTypeRegister) {
        return 3;
    } else {
        return 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - 逻辑处理方法
- (void)loginButton {
    self.type = LFBlogTypeLogin;
    [login setTitle:@"登  录" forState:UIControlStateNormal];
    loginView.frame = CGRectMake(0, 220, SCREEN_WIDTH, 130);
    [loginView reloadData];
}

- (void)forget {
    self.type = LFBlogTypeForget;
    [login setTitle:@"重新设置" forState:UIControlStateNormal];
    loginView.frame = CGRectMake(0, 220, SCREEN_WIDTH, 180);
    [loginView reloadData];
}

- (void)reg {
    self.type = LFBlogTypeRegister;
    [login setTitle:@"注  册" forState:UIControlStateNormal];
    loginView.frame = CGRectMake(0, 220, SCREEN_WIDTH, 180);
    [loginView reloadData];
}

- (void)login {
    [self normalLoginRequestStart];
    [self skipToRootView];
    if (self.type == LFBlogTypeLogin) {
//        [self normalLoginRequestStartWithUsername:accountText.text Password:passwordText.text];
    } else if (self.type == LFBlogTypeRegister) {
//        [self normalRegisterRequestStartWithPhoneNumber:accountText.text Validate:validateText.text Password:passwordText.text];
    } else if (self.type == LFBlogTypeForget) {
//        [self normalForgetRequestStartWithPhoneNumber:accountText.text Validate:validateText.text Password:passwordText.text];
    }
    
}

- (void)getValidate:(UIButton *)sender {
    if (self.type == LFBlogTypeRegister) {
//        [self registerGetValidateRequestStartWithPhoneNumber:accountText.text];;
    } else if (self.type == LFBlogTypeForget) {
//        [self forgetGetValidateRequestStartWithPhoneNumber:accountText.text];;
    } else {}
}

- (void)changePasswordState:(UIButton *)sender {
    if (cansee) {
        [sender setImage:[[UIImage imageNamed:@"cansee"]imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        passwordText.secureTextEntry = NO;
    } else {
        [sender setImage:[[UIImage imageNamed:@"cannotsee"]imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        passwordText.secureTextEntry = YES;
    }
    
    cansee = !cansee;
    passwordText.secureTextEntry = !passwordText.secureTextEntry;
}


- (void)normalLoginRequestStart {
    self.viewModel.userName = @"123456";
    self.viewModel.password = @"123456";
    @weakify(self);
    [[self.viewModel.normalLoginCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
        @strongify(self)
        [self queryUserInfoRequestStart];
    }];
}

- (void)queryUserInfoRequestStart {
    @weakify(self);
    [[self.viewModel.queryUserInfoCommand execute:nil] subscribeNext:^(NSDictionary *returnData) {
    }];
}

- (LoginViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc] init];
    }
    return _viewModel;
}

/**
 *    @brief    跳转至登录后主界面
 *  @discussion 成功登录读取数据后，跳转至主界面
 */
- (void)skipToRootView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *TabBarViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    [self presentViewController:TabBarViewController animated:YES completion:^{
        
    }];
}


@end
