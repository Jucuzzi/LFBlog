//
//  UIImage+GaussianBlur.h
//  HEMS
//  模糊分类
//  Created by daiyi on 16/2/23.
//  Copyright © 2016年 杭州天丽科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GaussianBlur)

/* blur the current image with a box blur algoritm */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur;

/* blur the current image with a box blur algoritm and tint with a color */
- (UIImage*)drn_boxblurImageWithBlur:(CGFloat)blur withTintColor:(UIColor*)tintColor;

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

- (UIImage *)downsampleImage;

@end
