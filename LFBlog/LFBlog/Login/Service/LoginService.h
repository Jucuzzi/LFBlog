//
//  LoginService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFBaseService.h"

@interface LoginService : LFBaseService

// 正常登录接口
- (void)normalLoginWithUsername:(NSString *)username
                            password:(NSString *)password
                             success:(successBlock)successBlock
                              failed:(faildBlock)failedBlock;

// 查询用户的所有信息
- (void)queryUserInfoWithUserId:(NSString *)userId
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock;

@end
