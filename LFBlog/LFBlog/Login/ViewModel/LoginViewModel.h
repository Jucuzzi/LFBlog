//
//  LoginViewModel.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseViewModel.h"

@interface LoginViewModel : LFBaseViewModel

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;


/***************************** 云端命令 ******************************/
/** 获得所有的资讯内容 */
@property (nonatomic, strong) RACCommand *normalLoginCommand;
/** 查询用户所有信息 */
@property (nonatomic, strong) RACCommand *queryUserInfoCommand;
/** 用户注册 */
@property (nonatomic, strong) RACCommand *registerCommand;

@end
