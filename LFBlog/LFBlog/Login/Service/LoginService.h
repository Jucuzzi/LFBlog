//
//  LoginService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LFBaseService.h"

@interface LoginService : LFBaseService

// 查询所有的资讯界面
- (void)queryInformationWithPageNumber:(NSString *)pageNumber
                             condition:(NSString *)condition
                         startedBlock :(ASIBasicBlock)startedBlock
                               completion:(ASIDataBlock)completionBlock
                                   failed:(ASIBasicBlock)failedBlock;

@end
