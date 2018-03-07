//
//  MeMainViewModel.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/6.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseViewModel.h"

@interface MeMainViewModel : LFBaseViewModel

@property (nonatomic, strong) UIImage *userIcon;

/***************************** 云端命令 ******************************/
/** 获得所有的资讯内容 */
@property (nonatomic, strong) RACCommand *uploadUserIconCommand;

@end
