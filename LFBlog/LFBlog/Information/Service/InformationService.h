//
//  InformationService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface InformationService : LFBaseService
/************************************  资讯主界面  ************************************/
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

/************************************  资讯详情界面  ************************************/
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

/************************************  评论界面  ************************************/
// 查询该条资讯下的所有评论
- (void)getCommentByInformationId:(NSString *)informationId
                          pageNum:(NSString *)pageNum
                          success:(successBlock)successBlock
                           failed:(faildBlock)failedBlock;

// 发表评论
- (void)addCommentById:(NSString *)informationId
         commentDetail:(NSString *)commentDetail
               success:(successBlock)successBlock
                failed:(faildBlock)failedBlock;

//删除评论
- (void)deleteCommentById:(NSString *)commentId
                  success:(successBlock)successBlock
                   failed:(faildBlock)failedBlock;

// 举报评论
- (void)reportCommentById:(NSString *)commentId
                 reportId:(NSString *)reportId
                  success:(successBlock)successBlock
                   failed:(faildBlock)failedBlock;

// 给评论点赞/取消赞
- (void)thumbWithThumbState:(BOOL)thumbState
                  commentId:(NSString *)commentId
                    success:(successBlock)successBlock
                     failed:(faildBlock)failedBlock;
@end
