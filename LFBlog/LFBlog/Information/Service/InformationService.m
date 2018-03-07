//
//  InformationService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "InformationService.h"

@implementation InformationService

- (void)queryInformationWithPageNumber:(NSInteger)pageNumber
                             condition:(NSString *)condition
                               success:(successBlock)successBlock
                                failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[NSString stringWithFormat:@"%ld",pageNumber] forKey:@"pageNumber"];
    [parameter setObject:condition forKey:@"condition"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"queryinformation" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)queryInformationWithPageNumber:(NSInteger)pageNumber
                                  type:(NSInteger)type
                             queryTime:(NSString *)queryTime
                               success:(successBlock)successBlock
                                failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[NSString stringWithFormat:@"%ld",pageNumber] forKey:@"pageNumber"];
    [parameter setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"type"];
    [parameter setObject:queryTime forKey:@"time"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"queryinformationByType" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)queryCollectionWithPageNumber:(NSInteger)pageNumber
                                  type:(NSInteger)type
                             queryTime:(NSString *)queryTime
                               success:(successBlock)successBlock
                                failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:[NSString stringWithFormat:@"%ld",pageNumber] forKey:@"pageNumber"];
    [parameter setObject:queryTime forKey:@"time"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"queryCollectionsByUser" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)queryInformationById:(NSString *)informationId
                                    success:(successBlock)successBlock
                                     failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:informationId forKey:@"informationId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"queryinformationById" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)queryCollectionById:(NSString *)informationId
                                    success:(successBlock)successBlock
                                     failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:informationId forKey:@"informationId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"queryCollectionsInfo" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)addCollectionWithId:(NSString *)informationId
                                    success:(successBlock)successBlock
                                     failed:(faildBlock)failedBlock{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:informationId forKey:@"informationId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"addCollections" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)deleteCollectionById:(NSString *)informationId
                                    success:(successBlock)successBlock
                                     failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:informationId forKey:@"informationId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"collectionDelete" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)getCommentByInformationId:(NSString *)informationId
                          pageNum:(NSString *)pageNum
                     success:(successBlock)successBlock
                      failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:informationId forKey:@"informationId"];
    [parameter setObject:pageNum forKey:@"pageNum"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"comment/getComments" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)addCommentById:(NSString *)informationId
         commentDetail:(NSString *)commentDetail
               success:(successBlock)successBlock
                failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:informationId forKey:@"informationId"];
    [parameter setObject:commentDetail forKey:@"commentDetail"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"comment/addComment" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)deleteCommentById:(NSString *)commentId
               success:(successBlock)successBlock
                failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:commentId forKey:@"commentId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"comment/deleteComment" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)reportCommentById:(NSString *)commentId
                 reportId:(NSString *)reportId
                  success:(successBlock)successBlock
                   failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:commentId forKey:@"commentId"];
    [parameter setObject:reportId forKey:@"reportType"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"comment/reported" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

- (void)thumbWithThumbState:(BOOL)thumbState
                  commentId:(NSString *)commentId
               success:(successBlock)successBlock
                failed:(faildBlock)failedBlock {
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameter setObject:commentId forKey:@"commentId"];
    NSString *url = @"";
    if (thumbState) {
        url = @"comment/cancelThumbsUp";
    } else {
        url = @"comment/thumbsUp";
    }
    [self.httpUtil AFNRequestPostWithParameter:parameter url:url success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

@end
