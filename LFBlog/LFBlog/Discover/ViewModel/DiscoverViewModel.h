//
//  DiscoverViewModel.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseViewModel.h"


@interface DiscoverViewModel : LFBaseViewModel

@property (nonatomic, strong) NSMutableArray *userList;

/***************************** 云端命令 ******************************/
/** 获得所有的用户资料 */
@property (nonatomic, strong) RACCommand *queryUserListCommand;

@end
