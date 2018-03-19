//
//  HeadModel.h
//  仿微信朋友圈
//
//  Created by 苗建浩 on 2017/5/31.
//  Copyright © 2017年 苗建浩. All rights reserved.
//

#import "BasicModel.h"

@interface HeadModel : BasicModel
@property (nonatomic, copy) NSString *detailContent;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *releaseTiem;
@property (nonatomic, copy) NSString *userIconPath;
@property (nonatomic, copy) NSString *pictureId;
@property (nonatomic, copy) NSString *sign;

@end
