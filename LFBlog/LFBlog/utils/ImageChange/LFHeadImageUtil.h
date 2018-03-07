//
//  HZHeadImageUtil.h
//  HEMS
//  变更图片工具
//  Created by 王力丰 on 16/5/22.
//  Copyright © 2016年 LiFeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^headImageUtilCBBlock)(UIImage *headImage);
typedef void(^headImageUtilDefaultOptionBlock)();

@interface LFHeadImageUtil : UIActionSheet

/*! @brief 添加默认图片选项
 *
 * @parameter desc 选项描述，可以为空，为空时显示“使用默认图像”
 * @parameter block 点击该选项执行操作
 */
- (void)addDefaultOptionsWithDes:(NSString *)desc defaultOptionClick:(headImageUtilDefaultOptionBlock)block;

///show
- (void)showWithCallBack:(headImageUtilCBBlock)imageCallBack;

@end

@interface UIViewController (Util)

/*! @brief 获取当前显示在界面上的主要控制器
 *
 * @return 返回当前界面控制器
 */
+ (UIViewController *)currentViewController;

@end
