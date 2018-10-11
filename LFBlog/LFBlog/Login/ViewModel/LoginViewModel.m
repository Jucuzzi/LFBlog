//
//  LoginViewModel.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginService.h"
#import "JSONKit.h"
#import "Singleton.h"
#import "AnalysisJSONToPlist.h"

@interface LoginViewModel ()

@property (nonatomic, strong) LoginService *service;

@end

@implementation LoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initData];
        [self initSignal];
        [self initNotification];
    }
    return self;
}

// 初始化配置，该方法中可能会执行部分命令，所以需要在init之后调用
- (void)bindComplete {
    [super bindComplete];
}

- (void)initData {
    self.service = [LoginService service];
//    self.userId = [Singleton sharedSingleton].userId;
//    self.userId = @"8a8a8bbf5e9e781f015e9e7861260008";
}

- (void)initNotification {
}

- (void)initSignal {
    /*********************************************** 网络请求命令 ************************************************/
    @weakify(self);
    _normalLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service normalLoginWithUsername:self.userName password:self.password success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                if ([returnDic[@"login"] isEqualToString:@"successed"]) {
                    [Singleton sharedSingleton].userId = returnDic[@"userId"];
                } else {
                    
                }
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _normalLoginCommand.allowsConcurrentExecution = YES;
    
    _registerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service registerWithUsername:self.userName password:self.password success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                if ([returnDic[@"login"] isEqualToString:@"successed"]) {
                    AnalysisJSONToPlist *toplist = [[AnalysisJSONToPlist alloc] init];
                    NSString *userId = [NSString stringWithFormat:@" {\"userId\":\"%@\"}",[returnDic objectForKey:@"userId"]];
                    [toplist analysisJSON:userId toPlist:@"userId"];
                    [Singleton sharedSingleton].userId = returnDic[@"userId"];
                } else {
                    
                }
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _registerCommand.allowsConcurrentExecution = YES;
    
    _queryUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryUserInfoWithUserId:[Singleton sharedSingleton].userId success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
//                // 模拟数据
//                [Singleton sharedSingleton].userId = @"8a8a8bbf5e9e781f015e9e7861260008";
                [Singleton sharedSingleton].username = returnDic[@"userName"];
                [Singleton sharedSingleton].nickName = returnDic[@"nickName"];
                [Singleton sharedSingleton].pictureId = returnDic[@"pictureId"];
                [Singleton sharedSingleton].userIconPath = [NSString stringWithFormat:@"%@%@",LFBlogUserIconPath,returnDic[@"userIconPath"]];
                [Singleton sharedSingleton].name = returnDic[@"name"];
                [Singleton sharedSingleton].sex = returnDic[@"sex"];
                [Singleton sharedSingleton].address = returnDic[@"address"];
                [Singleton sharedSingleton].birthday = returnDic[@"birthday"];
                [Singleton sharedSingleton].sign = returnDic[@"sign"];
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryUserInfoCommand.allowsConcurrentExecution = YES;
}


@end
