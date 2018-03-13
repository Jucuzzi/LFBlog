//
//  DynamicViewModel.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/13.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseViewModel.h"

@interface DynamicViewModel : LFBaseViewModel

@property (nonatomic, strong) NSString *detailContent;

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, assign) NSString *queryTime;
@property (nonatomic, strong) NSString *photoIds;

/** 发布动态接口 */
@property (nonatomic, strong) RACCommand *addDynamicCommand;
/** 查询动态接口 */
@property (nonatomic, strong) RACCommand *queryDynamicCommand;

/************************************  上传资讯的接口  ************************************/
/** 上传图片接口 */
@property (nonatomic, strong) RACCommand *uploadImageCommand;

@end
