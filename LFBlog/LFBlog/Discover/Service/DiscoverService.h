//
//  DiscoverService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface DiscoverService : LFBaseService

// 通过用户名查找用户
- (void)queryUserListByName:(NSString *)userName
                         success:(successBlock)successBlock
                          failed:(faildBlock)failedBlock;


@end
