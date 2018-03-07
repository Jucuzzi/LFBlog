//
//  LoginService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

- (void)normalLoginWithUsername:(NSString *)username
                             password:(NSString *)password
                               success:(successBlock)successBlock
                                failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:username forKey:@"username"];
    [parameter setObject:password forKey:@"password"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"frontStageUserlogin" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)queryUserInfoWithUserId:(NSString *)userId
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:userId forKey:@"userId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"queryUserInfo" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

@end
