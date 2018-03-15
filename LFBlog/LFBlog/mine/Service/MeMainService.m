//
//  MeMainService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "MeMainService.h"
#import "Singleton.h"

@implementation MeMainService

- (void)uploadUserIconWithUserId:(NSString *)userId
                    userIconData:(UIImage *)userIcon
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:userId forKey:@"userId"];
    [parameter setObject:[UIImageJPEGRepresentation(userIcon, 1) base64Encoding] forKey:@"userIconData"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"uploadUserIcon" success:^(id responseObject) {
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

- (void)updateUserInfoWithNickName:(NSString *)nickName
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:@"nickName" forKey:@"key"];
    [parameter setObject:nickName forKey:@"value"];
    [parameter setObject:[Singleton sharedSingleton].userId forKey:@"userId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"prvlg/updateUserWithParameter.do" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)updateUserInfoWithSex:(NSString *)sex
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:@"sex" forKey:@"key"];
    [parameter setObject:sex forKey:@"value"];
    [parameter setObject:[Singleton sharedSingleton].userId forKey:@"userId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"prvlg/updateUserWithParameter.do" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)updateUserInfoWithBirthday:(NSString *)birthday
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:@"birthday" forKey:@"key"];
    [parameter setObject:birthday forKey:@"value"];
    [parameter setObject:[Singleton sharedSingleton].userId forKey:@"userId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"prvlg/updateUserWithParameter.do" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)updateUserInfoWithAddress:(NSString *)address
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:@"address" forKey:@"key"];
    [parameter setObject:address forKey:@"value"];
    [parameter setObject:[Singleton sharedSingleton].userId forKey:@"userId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"prvlg/updateUserWithParameter.do" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)updateUserInfoWithSign:(NSString *)sign
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:@"sign" forKey:@"key"];
    [parameter setObject:sign forKey:@"value"];
    [parameter setObject:[Singleton sharedSingleton].userId forKey:@"userId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"prvlg/updateUserWithParameter.do" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

@end
