//
//  HttpUtil.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "HttpUtil.h"


@interface HttpUtil ()

@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, strong) NSMutableArray<ASIHTTPRequest *> *requestArr;

@end

@implementation HttpUtil

// POST未加密方法
- (void)RequestPostWithParameter:(NSDictionary *)parameter
                             url:(NSString *)url
                           start:(ASIBasicBlock)startedBlock
                         completion:(ASIDataBlock)completionBlock
                        failed:(ASIBasicBlock)failedBlock {
    ///当前时间
//    readDataFromPlist * readData = [[readDataFromPlist alloc] init];
//    NSString *uuid = [readData getValueForKeyFromPList:@"uuid" forKey:@"uuid"];
//    NSString *uuidtime = [readData getValueForKeyFromPList:@"uuidtime" forKey:@"uuidtime"];
//    NSMutableString * currentTime = [[NSMutableString alloc]initWithCapacity:1];
//    [currentTime appendString:uuid];
//    [currentTime appendString:uuidtime];
//    UpdateUUID
    ///md5加密
//    NSString *mad5Result = [self packageMad5Result:currentTime jsonParameter:parameter privateKey:[Singleton sharedSingleton].privateKey];
    ///post发送
    NSURL * urlForPost = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",LFBlogHttpService,url]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlForPost];
    [self.requestArr addObject:request];
    [request setRequestMethod:@"POST"];
    [request setValidatesSecureCertificate:NO];
    request.shouldAttemptPersistentConnection = NO;
    [parameter enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [request setPostValue:obj forKey:key];
    }];
    [request setTimeOutSeconds:15];
    [request setPostFormat:ASIURLEncodedPostFormat];
    [request setStringEncoding:NSUTF8StringEncoding];
    [request setDelegate:self];
    [request setStartedBlock:startedBlock];
    [request setDataReceivedBlock:^(NSData *data) {
        completionBlock(data);
    }];
    [request setFailedBlock:failedBlock];
    [request startAsynchronous];
}

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

- (void)dealloc {
    
    [_requestArr enumerateObjectsUsingBlock:^(ASIHTTPRequest *request, NSUInteger idx, BOOL * _Nonnull stop) {
        if (request) {
            [request clearDelegatesAndCancel];
        }
    }];
    
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
}

- (NSMutableArray<ASIHTTPRequest *> *)requestArr {
    if (!_requestArr) {
        _requestArr = [NSMutableArray array];
    }
    return _requestArr;
}

@end
