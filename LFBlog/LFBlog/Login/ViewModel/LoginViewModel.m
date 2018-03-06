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
    self.pageNumber = @"1";
    self.condition = @"";
}

- (void)initNotification {
}

- (void)initSignal {
    /*********************************************** 网络请求命令 ************************************************/
    @weakify(self);
    _queryInformationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryInformationWithPageNumber:self.pageNumber condition:self.condition startedBlock:^{
                [self.requestStartedSubject sendNext:nil];
            } completion:^(NSData *data) {
                NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.infoList = returnDic[@"infoList"];
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^{
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryInformationCommand.allowsConcurrentExecution = YES;
}


@end
