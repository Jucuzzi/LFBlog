//
//  HttpUtil.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef void(^successBlock)(id responseObject);
typedef void(^faildBlock)(NSError *error);

@interface HttpUtil : NSObject

// POST未加密方法
- (void)RequestPostWithParameter:(NSDictionary *)parameter
                             url:(NSString *)url
                           start:(ASIBasicBlock)startedBlock
                         success:(successBlock)successBlock
                          failed:(faildBlock)failedBlock;

// AFN请求方法
- (void)AFNRequestPostWithParameter:(NSDictionary *)parameter
                             url:(NSString *)url
                            success:(successBlock)successBlock
                             failed:(faildBlock)failedBlock;

@end
