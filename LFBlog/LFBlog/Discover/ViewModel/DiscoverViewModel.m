//
//  DiscoverViewModel.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "DiscoverViewModel.h"
#import "DiscoverService.h"

@interface DiscoverViewModel ()

@property (nonatomic, strong) DiscoverService *service;

@end

@implementation DiscoverViewModel

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
    self.service = [DiscoverService service];
    //    self.userId = [Singleton sharedSingleton].userId;
}

- (void)initNotification {
}

- (void)initSignal {
    /*********************************************** 网络请求命令 ************************************************/
    @weakify(self);
    _queryUserListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryUserListByName:input success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                self.userList = returnDic[@"root"];
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryUserListCommand.allowsConcurrentExecution = YES;
    
    _queryTagsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryTagsWithSuccess:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                self.tagList = returnDic[@"tagList"];
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryTagsCommand.allowsConcurrentExecution = YES;
}

@end
