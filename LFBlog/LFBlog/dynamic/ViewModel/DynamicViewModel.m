//
//  DynamicViewModel.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/13.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "DynamicViewModel.h"
#import "DynamicService.h"

@interface DynamicViewModel ()

@property (nonatomic, strong) DynamicService *service;

@end


@implementation DynamicViewModel

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
    self.service = [DynamicService service];
    self.pageNumber = 1;
    self.condition = @"";
    self.queryTime = @"";
}

- (void)initNotification {
}

- (void)initSignal {
    /*********************************************** 网络请求命令 ************************************************/
    @weakify(self);
    _addDynamicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service addDynamicWithTopicId:@"" pictureId:self.photoIds detailContent:self.detailContent success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
//                //重新设置数据
//                self.infoList = [[NSMutableArray alloc]initWithCapacity:1];
//                [self.infoList addObjectsFromArray:returnDic[@"infoList"]];
//                NSInteger count = 0;
//                count = [returnDic[@"infoList"] count];
//                //放入没有数据的视图
//                if (count == 0) {
//                }
//                //把最后一名数据的id记下来
//                self.queryTime = returnDic[@"time"];
//                self.pageNumber += 1;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _addDynamicCommand.allowsConcurrentExecution = YES;
    
    _queryDynamicCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryDynamicWithPageNumber:self.pageNumber condition:self.condition queryTime:self.queryTime success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                //                //重新设置数据
                //                self.infoList = [[NSMutableArray alloc]initWithCapacity:1];
                //                [self.infoList addObjectsFromArray:returnDic[@"infoList"]];
                //                NSInteger count = 0;
                //                count = [returnDic[@"infoList"] count];
                //                //放入没有数据的视图
                //                if (count == 0) {
                //                }
                //                //把最后一名数据的id记下来
                //                self.queryTime = returnDic[@"time"];
                //                self.pageNumber += 1;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryDynamicCommand.allowsConcurrentExecution = YES;
    
    _uploadImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage *img) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service uploadImageWithImage:img success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                @strongify(self);
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _uploadImageCommand.allowsConcurrentExecution = YES;
    
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
}
@end
