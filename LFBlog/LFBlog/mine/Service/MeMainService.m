//
//  MeMainService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "MeMainService.h"

@implementation MeMainService

- (void)uploadUserIconWithUserId:(NSString *)userId
                    userIconData:(UIImage *)userIcon
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:userId forKey:@"userId"];
    [parameter setObject:[UIImageJPEGRepresentation(userIcon, 1) base64Encoding] forKey:@"userIconData"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"uploadUserIcon" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

@end
