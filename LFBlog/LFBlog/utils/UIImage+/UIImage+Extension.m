//
//  UIImage+Extension.m
//  HEMS
//  UIImage扩展功能分类
//  Created by daiyi on 16/2/18.
//  Copyright © 2016年 杭州天丽科技有限公司. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

/**
 *  @brief  根据颜色生成纯色图片
 *  @param  color  颜色
 *  @param  size  尺寸
 *  @return UIImage  生成的纯色图片
 *  @discussion 根据颜色生成纯色图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *imgFromColor = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgFromColor;
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size alpha:(CGFloat)alpha
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *imgFromColor = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgFromColor;
}

/**
 *  @brief  根据颜色改变图片填充色
 *  @param  color  颜色
 *  @return UIImage  已改变颜色的图片
 *  @discussion 根据颜色改变图片填充色
 */
- (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

///压缩图像
- (UIImage *)downsampleImage
{
    NSData *imageAsData = UIImageJPEGRepresentation(self, 0.001);
    UIImage *downsampledImaged = [UIImage imageWithData:imageAsData];
    return downsampledImaged;
}

+ (UIImage *)imageWithName:(NSString *)imageName Alpha:(CGFloat)alpha
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    layer.contents = (id)image.CGImage;
    layer.opacity = alpha;
    
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageWithAlpha:(CGFloat)alpha radius:(CGFloat)radius
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    layer.contents = (id)self.CGImage;
    layer.opacity = alpha;
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)makeCircleImageWithClearBorder:(CGFloat)borderWidth toSize:(CGSize)size
{
    CGFloat imageWidth = MIN(size.width, size.height);
    UIGraphicsBeginImageContextWithOptions((CGSize){imageWidth, imageWidth}, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CALayer *bcgLayer = [CALayer layer];
    bcgLayer.bounds = CGRectMake(0, 0, imageWidth, imageWidth);
    bcgLayer.shouldRasterize = YES;     //CPU缓存减少离屏渲染压力
    bcgLayer.rasterizationScale = [UIScreen mainScreen].scale;
    bcgLayer.cornerRadius = imageWidth / 2;
    bcgLayer.borderWidth = borderWidth;
    bcgLayer.borderColor = [UIColor whiteColor].CGColor;
    
    CALayer *imagelayer = [CALayer layer];
    imagelayer.bounds = CGRectMake(0, 0, imageWidth - borderWidth * 2, imageWidth - borderWidth * 2);
    imagelayer.position = CGPointMake(imageWidth * 0.5, imageWidth * 0.5);
    imagelayer.contents = (__bridge id _Nullable)(self.CGImage);
    imagelayer.shouldRasterize = YES;
    imagelayer.rasterizationScale = [UIScreen mainScreen].scale;
    imagelayer.cornerRadius = imageWidth * 0.5 - borderWidth;
    imagelayer.masksToBounds = YES;
    [bcgLayer addSublayer:imagelayer];
    
    [bcgLayer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageFromScreenshotWithView:(UIView *)screenshotView
{
    UIGraphicsBeginImageContextWithOptions(screenshotView.frame.size, NO, 0);
    [screenshotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)iOSImageProcess:(UIImage *)image {
    /************************************  获取图片大小  ************************************/
    CGImageRef imageRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    /************************************  创建颜色空间(明确图片什么类型)1.彩色图片 2.灰色图片  ************************************/
    // 查看OpenCV源码实现(预览源码)
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    /************************************  创建图片上下文  ************************************/
    // 参数一.数据源
    // 参数二.图片高
    // 参数三.图片高
    // 参数四.每一个像素点,每一个分量大小ARGB每一个颜色,称之为一个分量,一共四个分量-->固定大小8位
    // 参数五.每一行占用的内存大小(首先计算一个像素的大小 = 4*8 = 32位 = 4字节,其次计算每一行的大小,width*4)
    // 参数六.颜色空间
    // 参数七.是否需要透明度ARGB(是否需要A)
    // 说明:参数七如果要深入研究,需要了解计算机的字节序(比较底层)大端字节序,小端字节序
    CGContextRef contextRef = CGBitmapContextCreate(nil, width, height, 8, width*4, colorSpace, kCGImageAlphaPremultipliedLast);
    /************************************  根据图片上下文绘制图片  ************************************/
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    /************************************  根据图片上下文获取刚创建的图片  ************************************/
    unsigned char * imageData = (unsigned char*)CGBitmapContextGetData(contextRef);
    /************************************  开始图像处理->打码处理  ************************************/
    // 首先:分析打码原理
    int currentIndex = 0;
    int preIndex = 0;
    int level = 10;
    //定义一个像素点数组,用于保存像素点的值(ARGB)
    unsigned char pixels[4] = {0};
    // 外层循环控制行,内层循环控制列
    for (int i = 0;i<height - 1;i++) {
        for (int j = 0; j<width - 1;i++) {
            // 计算当前遍历的位置
            currentIndex = i*width+j;
            // 首先获取马赛克点第一行第一列的像素值
            if (i%level == 0){
                if (j %level == 0) {
                    // 马赛克矩形第一行,第一列
                    // 获取像素点的值
                    // C语言数据拷贝
                    // 参数一.目标数据(拷贝到哪里) 参数二.数据源(从哪里拷贝) 参数三.拷贝多少内容
                    memcpy(pixels, imageData +4*currentIndex, 4);
                }else {
                    //其他列
                    //将第一个像素点的值赋值给其他的像素点(在同一列赋值)
                    //实现:也是通过C函数拷贝
                    memcpy(imageData +4 * currentIndex, pixels, 4);
                }
            }else {
                // 马赛克矩形其他行
                // 马赛克矩形第二行.第三行等等
                // 计算上一行马赛克的点的位置(相对于上一行)
                preIndex = (i-1)*width+j;
                // 同样也是C函数拷贝,src位置表示上一行,dst位置表示当前行
                memcpy(imageData +4*currentIndex, imageData +4*preIndex, 4);
            }
        }
    }
    /************************************  获取图片数据集合  ************************************/
    CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL, imageData, width*height*4, NULL);
    /************************************  创建马赛克图片  ************************************/
    // 参数:一:图片宽 二:图片高 三:每一个像素点,每一个分量的大小 四:每一个像素点占用内存大小 五:每一行占用内存大小, 六:颜色空间 七:是否需要透明度 八:数据集合 九:数据解码器 十:是否抗锯齿 十一:图片渲染器
    CGImageRef mosaicImageRef = CGImageCreate(width, height, 8, 32, width*4, colorSpace, kCGImageAlphaPremultipliedLast, providerRef, NULL, NO, kCGRenderingIntentDefault);
    /************************************  创建输出图片(用于显示UI)  ************************************/
    CGContextRef outputContextRef = CGBitmapContextCreate(nil, width, height, 8, 4*width, colorSpace,kCGImageAlphaPremultipliedLast );
    CGContextDrawImage(outputContextRef, CGRectMake(0, 0, width, height), mosaicImageRef);
    CGImageRef outputImageRef = CGBitmapContextCreateImage(outputContextRef);
    UIImage *outputImage = [UIImage imageWithCGImage:outputImageRef];
    /************************************  释放内存  ************************************/
    CGImageRelease(outputImageRef);
    CGImageRelease(mosaicImageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(providerRef);
    CGContextRelease(contextRef);
    CGContextRelease(outputContextRef);
    return nil;
}

@end
