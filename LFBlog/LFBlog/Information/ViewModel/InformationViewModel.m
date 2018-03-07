//
//  InformationViewModel.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "InformationViewModel.h"
#import "InformationService.h"
#import "JSONKit.h"

@interface InformationViewModel ()

@property (nonatomic, strong) InformationService *service;

@end

@implementation InformationViewModel

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
    self.service = [InformationService service];
    self.pageNumber = 1;
    self.type = 1;
    self.queryTime = @"";
    self.condition = @"";
    self.infoList = [[NSMutableArray alloc]initWithCapacity:1];
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
            [self.service queryInformationWithPageNumber:self.pageNumber type:self.type queryTime:self.queryTime success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                //重新设置数据
                self.infoList = [[NSMutableArray alloc]initWithCapacity:1];
                [self.infoList addObjectsFromArray:returnDic[@"infoList"]];
                NSInteger count = 0;
                count = [returnDic[@"infoList"] count];
                //放入没有数据的视图
                if (count == 0) {
                }
                //把最后一名数据的id记下来
                self.queryTime = returnDic[@"time"];
                self.pageNumber += 1;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryInformationCommand.allowsConcurrentExecution = YES;
    
    _queryCollectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryCollectionWithPageNumber:self.pageNumber type:self.type queryTime:self.queryTime success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                //重新设置数据
                self.infoList = [[NSMutableArray alloc]initWithCapacity:1];
                [self.infoList addObjectsFromArray:returnDic[@"collectList"]];
                NSInteger count = 0;
                count = [returnDic[@"collectList"] count];
                //放入没有数据的视图
                if ([returnDic[@"collectList"] count] == 0) {
                }
                //把最后一名数据的id记下来
                self.queryTime = returnDic[@"time"];
                self.pageNumber += 1;
                
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryCollectionCommand.allowsConcurrentExecution = YES;
    
    _queryInformationDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryInformationById:self.selectedInformationId success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                self.infoDetailData = returnDic;
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryInformationDetailCommand.allowsConcurrentExecution = YES;
    
    _queryInformationCollectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service queryCollectionById:self.selectedInformationId success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                self.collectNum = [NSString stringWithFormat:@"%@",returnDic[@"collectNum"]];
                self.isCollect = [NSString stringWithFormat:@"%@",returnDic[@"isCollect"]];
                self.commentNum = [NSString stringWithFormat:@"%@",returnDic[@"commentNum"]];
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _queryInformationCollectionCommand.allowsConcurrentExecution = YES;
    
    _addToCollectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service addCollectionWithId:self.selectedInformationId success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                self.collectNum = [NSString stringWithFormat:@"%d",self.collectNum.intValue +1];
                self.isCollect = @"1";
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                @strongify(self);
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _addToCollectionCommand.allowsConcurrentExecution = YES;
    
    _deleteFromCollectionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service deleteCollectionById:self.selectedInformationId success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                self.collectNum = [NSString stringWithFormat:@"%d",self.collectNum.intValue -1];
                self.isCollect = @"0";
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                @strongify(self);
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _deleteFromCollectionCommand.allowsConcurrentExecution = YES;
    
    _queryCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service getCommentByInformationId:self.selectedInformationId pageNum:self.commentPageNumber success:^(id responseObject) {
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
    _queryCommentCommand.allowsConcurrentExecution = YES;
    
    _addCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service addCommentById:self.selectedInformationId commentDetail:self.commentDetail success:^(id responseObject) {
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
    _addCommentCommand.allowsConcurrentExecution = YES;
    
    _deleteCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service deleteCommentById:self.commentId success:^(id responseObject) {
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
    _deleteCommentCommand.allowsConcurrentExecution = YES;
    
    _reportCommentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service reportCommentById:self.commentId reportId:self.reportType success:^(id responseObject) {
                @strongify(self);
                NSDictionary *returnDic = responseObject;
                self.collectNum = [NSString stringWithFormat:@"%d",self.collectNum.intValue -1];
                self.isCollect = @"0";
                [subscriber sendNext:returnDic];
                [subscriber sendCompleted];
            } failed:^(NSError *error) {
                @strongify(self);
                [self.requestFailedSubject sendNext:nil];
            }];
            return nil;
        }];
    }];
    _reportCommentCommand.allowsConcurrentExecution = YES;
    
    _thumbOrNotCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
//            BOOL thumb = NO;
//            if ([thumbState isEqualToString:@"1"]) {
//                thumb = YES;
//            } else {
//                thumb = NO;
//            }
            /******************************** 网络请求 *********************************/
            @weakify(self);
            [self.service thumbWithThumbState:self.thumbState commentId:self.commentId success:^(id responseObject) {
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
    _thumbOrNotCommand.allowsConcurrentExecution = YES;
}


@end
