//
//  LFBaseService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpUtil.h"

@interface LFBaseService : NSObject

@property (nonatomic, strong, readonly) HttpUtil *httpUtil;

+ (instancetype)service;

@end
