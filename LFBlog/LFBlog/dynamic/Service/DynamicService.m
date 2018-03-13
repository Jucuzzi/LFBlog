//
//  DynamicService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/9.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "DynamicService.h"
#import "Singleton.h"

@implementation DynamicService

// 发布个人动态
- (void)addDynamicWithTopicId:(NSString *)topicId
                    pictureId:(NSString *)pictureId
                detailContent:(NSString *)detailContent
                      success:(successBlock)successBlock
                       failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[Singleton sharedSingleton].userId forKey:@"userId"];
    [parameter setObject:topicId forKey:@"topicId"];
    [parameter setObject:pictureId forKey:@"pictureId"];
    [parameter setObject:detailContent forKey:@"detailContent"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"addDynamic" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

// 查询你能看到的所有动态
- (void)queryDynamicWithPageNumber:(NSInteger)pageNumber
                            condition:(NSString *)condition
                         queryTime:(NSString *)queryTime
                           success:(successBlock)successBlock
                            failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[NSString stringWithFormat:@"%ld",pageNumber] forKey:@"pageNumber"];
    [parameter setObject:condition forKey:@"condition"];
    [parameter setObject:queryTime forKey:@"time"];
    [parameter setObject:[Singleton sharedSingleton].userId forKey:@"userId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"queryDynamic" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}


- (void)uploadImageWithImage:(UIImage *)image
                     success:(successBlock)successBlock
                      failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[UIImageJPEGRepresentation(image, 1) base64Encoding] forKey:@"photoData"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"addPhoto" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}
@end
