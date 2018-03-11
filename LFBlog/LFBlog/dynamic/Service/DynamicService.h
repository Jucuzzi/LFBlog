//
//  DynamicService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface DynamicService : LFBaseService

// 上传用户头像
- (void)addDynamicWithUserId:(NSString *)userId
                     topicId:(NSString *)topicId
                    userIconData:(UIImage *)userIcon
                         success:(successBlock)successBlock
                          failed:(faildBlock)failedBlock;

@end
