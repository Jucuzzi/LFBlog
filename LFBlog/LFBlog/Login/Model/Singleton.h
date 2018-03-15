//
//  SingleTon.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/5.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

+ (Singleton *)sharedSingleton;
// 8a8a8bbf5e9e781f015e9e7861260008
@property (nonatomic, retain) NSString *uuid;
// 2910
@property (nonatomic, retain) NSString *userId;
// 用户名，和密码是一对
@property (nonatomic, retain) NSString *username;
// hems2910
@property (nonatomic, retain) NSString *name;
// userPhoto-201706161424-2910
@property (nonatomic, retain) NSString *pictureId;
// UserPic/20170920/ec89563560804d788fdcfbccd0d8837f.png
@property (nonatomic, retain) NSString *userIconPath;
// 昵称
@property (nonatomic, retain) NSString *nickName;
// 男
@property (nonatomic, retain) NSString *sex;
// 1994-04-14
@property (nonatomic, retain) NSString *birthday;
// 浙江省建德市
@property (nonatomic, retain) NSString *address;
// EL-PSY-CONGROO
@property (nonatomic, retain) NSString *sign;

@end
