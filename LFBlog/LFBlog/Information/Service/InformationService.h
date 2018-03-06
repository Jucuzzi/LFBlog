//
//  InformationService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface InformationService : LFBaseService

// 查询所有的资讯界面
- (void)queryInformationWithPageNumber:(NSInteger)pageNumber
                             condition:(NSString *)condition
                               success:(successBlock)successBlock
                                failed:(faildBlock)failedBlock;

// 根据类型和时间查询所有的资讯界面
- (void)queryInformationWithPageNumber:(NSInteger)pageNumber
                                  type:(NSInteger)type
                             queryTime:(NSString *)queryTime
                               success:(successBlock)successBlock
                                failed:(faildBlock)failedBlock;

// 根据用户查询用户收藏的资讯
- (void)queryCollectionWithPageNumber:(NSInteger)pageNumber
                                 type:(NSInteger)type
                            queryTime:(NSString *)queryTime
                              success:(successBlock)successBlock
                               failed:(faildBlock)failedBlock;

// 查询资讯详情
- (void)queryInformationById:(NSString *)informationId
                     success:(successBlock)successBlock
                      failed:(faildBlock)failedBlock;

//查询资讯的收藏情况
- (void)queryCollectionById:(NSString *)informationId
                    success:(successBlock)successBlock
                     failed:(faildBlock)failedBlock;

// 把资讯加入收藏
- (void)addCollectionWithId:(NSString *)informationId
                    success:(successBlock)successBlock
                     failed:(faildBlock)failedBlock;

// 把资讯移出收藏
- (void)deleteCollectionById:(NSString *)informationId
                     success:(successBlock)successBlock
                      failed:(faildBlock)failedBlock;

@end
