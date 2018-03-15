//
//  MeMainViewModel.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "MeMainViewModel.h"
#import "MeMainService.h"
#import "JSONKit.h"
#import "Singleton.h"

@interface MeMainViewModel ()

@property (nonatomic, strong) MeMainService *service;

@end

@implementation MeMainViewModel

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
    self.service = [MeMainService service];
    //    self.userId = [Singleton sharedSingleton].userId;
}

- (void)initNotification {
}

- (void)initSignal {
    /*********************************************** 网络请求命令 ************************************************/
    @weakify(self);
    _uploadUserIconCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service uploadUserIconWithUserId:[Singleton sharedSingleton].userId userIconData:self.userIcon success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _uploadUserIconCommand.allowsConcurrentExecution = YES;
    
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
                [Singleton sharedSingleton].sex = returnDic[@"sex"];
                [Singleton sharedSingleton].address = returnDic[@"address"];
                [Singleton sharedSingleton].birthday = returnDic[@"birthday"];
                [Singleton sharedSingleton].sign = returnDic[@"sign"];
                
                [Singleton sharedSingleton].userIconPath = [NSString stringWithFormat:@"%@%@",LFBlogUserIconPath,returnDic[@"userIconPath"]];
                [Singleton sharedSingleton].name = returnDic[@"name"];
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryUserInfoCommand.allowsConcurrentExecution = YES;
    
    _updateNickNameCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *nickName) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service updateUserInfoWithNickName:nickName success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _updateNickNameCommand.allowsConcurrentExecution = YES;
    
    _updateSexCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *sex) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service updateUserInfoWithSex:sex success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _updateSexCommand.allowsConcurrentExecution = YES;
    
    _updateBirthdayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *birthday) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service updateUserInfoWithBirthday:birthday success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _updateBirthdayCommand.allowsConcurrentExecution = YES;
    
    _updateAddressCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *address) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service updateUserInfoWithAddress:address success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _updateAddressCommand.allowsConcurrentExecution = YES;
    
    _updateSignCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *sign) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service updateUserInfoWithSign:sign success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _updateSignCommand.allowsConcurrentExecution = YES;
}


@end
