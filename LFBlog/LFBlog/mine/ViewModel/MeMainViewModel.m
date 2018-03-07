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
}


@end
