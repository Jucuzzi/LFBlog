//
//  LFBaseService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface LFBaseService ()

@property (nonatomic, strong) HttpUtil *httpUtil;

@end

@implementation LFBaseService

+ (instancetype)service {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        _httpUtil = [[HttpUtil alloc] init];
    }
    return self;
}

@end
