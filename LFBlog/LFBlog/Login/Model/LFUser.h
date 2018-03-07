//
//  LFUser.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/5.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const UserPhotoDidChangeNotification;
UIKIT_EXTERN NSString *const UserNickNameDidChangeNotification;

@interface LFUser : NSObject

/** 构造方法 */
+ (instancetype)sharedUser;

/** 昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 头像id */
@property (nonatomic, copy, readonly) NSString *userPhotoId;
/** 获取用户最新头像 */
+ (UIImage *)getUserLastestPhoto;

- (void)updateUserPhotoId:(NSString *)userPhotoId
                    image:(UIImage *)image;

@end
