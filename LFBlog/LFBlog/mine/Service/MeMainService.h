//
//  MeMainService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface MeMainService : LFBaseService

// 上传用户头像
- (void)uploadUserIconWithUserId:(NSString *)userId
                    userIconData:(UIImage *)userIcon
                        success:(successBlock)successBlock
                         failed:(faildBlock)failedBlock;

@end
