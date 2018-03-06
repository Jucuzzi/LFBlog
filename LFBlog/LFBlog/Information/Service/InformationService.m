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
    [parameter setObject:informationId forKey:@"informationId"];
    [self.httpUtil AFNRequestPostWithParameter:parameter url:@"collectionDelete" success:^(id responseObject) {
        successBlock(responseObject);
    } failed:^(NSError * _Nonnull error) {
        failedBlock(error);
    }];
}

@end
