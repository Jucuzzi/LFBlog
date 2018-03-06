//
//  LFBaseViewModel.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveObjC.h"

@interface LFBaseViewModel : NSObject

/***************************** 操作信号 ******************************/
/** 网络请求失败信号 */
@property (nonatomic, strong) RACSubject *requestFailedSubject;
/** 网络请求开始信号 */
@property (nonatomic, strong) RACSubject *requestStartedSubject;

- (void)bindComplete;

@end
