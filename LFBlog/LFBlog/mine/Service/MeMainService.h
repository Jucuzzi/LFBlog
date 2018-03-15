//
//  MeMainService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface MeMainService : LFBaseService

// 上传用户头像
- (void)uploadUserIconWithUserId:(NSString *)userId
                    userIconData:(UIImage *)userIcon
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock;

// 获取用户的信息
- (void)queryUserInfoWithUserId:(NSString *)userId
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock;

//更新用户的昵称
- (void)updateUserInfoWithNickName:(NSString *)nickName
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock;

// 更新用户的性别
- (void)updateUserInfoWithSex:(NSString *)sex
                      success:(successBlock)successBlock
                       failed:(faildBlock)failedBlock;

// 更新用户的生日
- (void)updateUserInfoWithBirthday:(NSString *)birthday
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock;

// 更新用户的地址
- (void)updateUserInfoWithAddress:(NSString *)address
                          success:(successBlock)successBlock
                           failed:(faildBlock)failedBlock;

// 更新用户的签名
- (void)updateUserInfoWithSign:(NSString *)sign
                       success:(successBlock)successBlock
                        failed:(faildBlock)failedBlock;
@end
