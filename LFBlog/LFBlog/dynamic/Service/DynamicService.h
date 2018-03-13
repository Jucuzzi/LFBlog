//
//  DynamicService.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFBaseService.h"

@interface DynamicService : LFBaseService

// 发布个人动态
- (void)addDynamicWithTopicId:(NSString *)topicId
                    pictureId:(NSString *)pictureId
                   detailContent:(NSString *)detailContent
                         success:(successBlock)successBlock
                          failed:(faildBlock)failedBlock;

// 查询你能看到的所有动态
- (void)queryDynamicWithPageNumber:(NSInteger)pageNumber
                         condition:(NSString *)condition
                         queryTime:(NSString *)queryTime
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock;

// 上传动态中的图片
- (void)uploadImageWithImage:(UIImage *)image
                     success:(successBlock)successBlock
                      failed:(faildBlock)failedBlock;
@end
