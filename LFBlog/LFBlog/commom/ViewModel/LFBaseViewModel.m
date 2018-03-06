//
//  LFBaseViewModel.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseViewModel.h"

@implementation LFBaseViewModel : NSObject

- (instancetype)init {
    if (self = [super init]) {
        //        [self initData];
        //        [self initSignal];
        //        [self initNotification];
        //
        //        _addTypeModelArr = [HZAddTypeModel addTypeModelList];
        //        self.httputil = [[HttpUtil alloc] init];
        
        _requestFailedSubject = [RACSubject subject];
        _requestStartedSubject = [RACSubject subject];
    }
    return self;
}

- (void)bindComplete {
    
}

@end
