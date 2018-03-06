//
//  LoginService.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

- (void)queryInformationWithPageNumber:(NSString *)pageNumber
                             condition:(NSString *)condition
                         startedBlock :(ASIBasicBlock)startedBlock
                               completion:(ASIDataBlock)completionBlock
                                   failed:(ASIBasicBlock)failedBlock {
//    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithCapacity:1];
//    [parameter setObject:pageNumber forKey:@"pageNumber"];
//    [parameter setObject:condition forKey:@"condition"];
//    [self.httpUtil RequestPostWithParameter:parameter url:@"queryinformation" start:^{
//        startedBlock();
//    } completion:^(NSData *data){
//        completionBlock(data);
//    } failed:^{
//        failedBlock();
//    }];
}

@end
