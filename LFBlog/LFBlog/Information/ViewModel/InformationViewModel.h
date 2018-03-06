//
//  InformationViewModel.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseViewModel.h"

@interface InformationViewModel : LFBaseViewModel

@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSMutableArray *infoList;
@property (nonatomic, strong) NSDictionary *infoDetailData;

///选中的资讯ID
@property (nonatomic, strong) NSString *selectedInformationId;
//此条资讯被收藏的数量
@property (nonatomic, strong) NSString *collectNum;
//是否被当前用户收藏
@property (nonatomic, strong) NSString *isCollect;
//评论的条数
@property (nonatomic, strong) NSString *commentNum;
//查询时间（最后一条的）用于记录查看到的位置
@property (nonatomic, strong) NSString *queryTime;

/***************************** 云端命令 ******************************/
/** 获得所有的资讯内容 */
@property (nonatomic, strong) RACCommand *queryInformationCommand;
/** 获得用户收藏的所有的资讯 */
@property (nonatomic, strong) RACCommand *queryCollectionCommand;
/** 查询资讯的内容 */
@property (nonatomic, strong) RACCommand *queryInformationDetailCommand;
/** 查询资讯的收藏情况 */
@property (nonatomic, strong) RACCommand *queryInformationCollectionCommand;
/** 将资讯加入收藏 */
@property (nonatomic, strong) RACCommand *addToCollectionCommand;
/** 将资讯移除收藏 */
@property (nonatomic, strong) RACCommand *deleteFromCollectionCommand;

@end
