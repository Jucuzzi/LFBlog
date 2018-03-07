//
//  HttpUtil.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "HttpUtil.h"


@interface HttpUtil ()

@end

@implementation HttpUtil

// POST未加密方法
- (void)AFNRequestPostWithParameter:(NSDictionary *)parameter
                             url:(NSString *)url
                           success:(successBlock)successBlock
                             failed:(faildBlock)failedBlock ; {
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [mgr POST:[NSString stringWithFormat:@"%@%@",LFBlogHttpService,url] parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success:%@",responseObject);
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error:%@",error);
        failedBlock(error);
    }];
}


@end
