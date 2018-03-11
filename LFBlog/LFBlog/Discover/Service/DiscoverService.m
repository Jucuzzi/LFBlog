//
//  DiscoverService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "DiscoverService.h"
#import "Singleton.h"

@implementation DiscoverService

// 通过用户名查找用户
- (void)queryUserListByName:(NSString *)userName
                    success:(successBlock)successBlock
                     failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:userName forKey:@"condition"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"prvlg/userlist.do" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

@end
