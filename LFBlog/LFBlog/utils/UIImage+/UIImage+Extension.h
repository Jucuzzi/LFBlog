//
//  UIImage+Extension.h
//  HEMS
//  UIImage扩展功能分类
//  Created by daiyi on 16/2/18.
//  Copyright © 2016年 杭州天丽科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  @brief  根据颜色生成纯色图片
 *  @param  color  颜色
 *  @param  size  尺寸
 *  @return UIImage  生成的纯色图片
 *  @discussion 根据颜色生成纯色图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size;
/**
 *  @brief  根据颜色改变图片填充色
 *  @param  color  颜色
 *  @return UIImage  已改变颜色的图片
 *  @discussion 根据颜色改变图片填充色
 */
- (UIImage *)imageWithColor:(UIColor *)color;

///压缩图像
- (UIImage *)downsampleImage;

///带有透明度的图像
+ (UIImage *)imageWithName:(NSString *)imageName Alpha:(CGFloat)alpha;

///带透明度的纯色图片
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha;

///对图像进行透明度与圆角处理
- (UIImage *)imageWithAlpha:(CGFloat)alpha radius:(CGFloat)radius;

///制作带白色边框的圆形image
- (UIImage *)makeCircleImageWithClearBorder:(CGFloat)borderWidth toSize:(CGSize)size;

/** 截图 */
+ (UIImage *)imageFromScreenshotWithView:(UIView *)screenshotView;

+ (UIImage *)iOSImageProcess:(UIImage *)image;



@end
