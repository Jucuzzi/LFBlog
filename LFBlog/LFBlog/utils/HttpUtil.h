//
//  HttpUtil.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^successBlock)(id responseObject);
typedef void(^faildBlock)(NSError *error);

@interface HttpUtil : NSObject

// AFN请求方法
- (void)AFNRequestPostWithParameter:(NSDictionary *)parameter
                             url:(NSString *)url
                            success:(successBlock)successBlock
                             failed:(faildBlock)failedBlock;

@end
