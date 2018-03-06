//
//  LoginViewModel.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseViewModel.h"

@interface LoginViewModel : LFBaseViewModel

@property (nonatomic, strong) NSString *pageNumber;
@property (nonatomic, strong) NSString *condition;

@property (nonatomic, strong) NSMutableArray *infoList;

/***************************** 云端命令 ******************************/
/** 获得所有的资讯内容 */
@property (nonatomic, strong) RACCommand *queryInformationCommand;

@end
