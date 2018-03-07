//
//  HZHeadImageUtil.m
//  HEMS
//  变更图片工具
//  Created by 王力丰 on 16/5/22.
//  Copyright © 2016年 LiFeng Wang. All rights reserved.
//

#import "LFHeadImageUtil.h"

@interface LFHeadImageUtil ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

/** 当前VC */
@property (nonatomic, weak) UIViewController *currentVC;
/** 已选择图片回调操作 */
@property (nonatomic, copy) headImageUtilCBBlock callBackBlock;
/** 选择默认选项回调操作 */
@property (nonatomic, copy) headImageUtilDefaultOptionBlock defOptionBlock;

@property (nonatomic, copy) NSString *defaultOptionDesc;

@property (nonatomic, assign) UIStatusBarStyle orignStatusBarStyle;

@end

@implementation LFHeadImageUtil

- (void)showWithCallBack:(headImageUtilCBBlock)imageCallBack
{
    self.currentVC = [UIViewController currentViewController];
    self.callBackBlock = imageCallBack;
    
    _orignStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    UIActionSheet *actionSheet;
    
    if (self.defOptionBlock) {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照",@"从相册选择", self.defaultOptionDesc ? self.defaultOptionDesc : @"使用默认图像", nil];
    }else {
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    
    [actionSheet showInView:self.currentVC.view];
}

- (void)addDefaultOptionsWithDes:(NSString *)desc defaultOptionClick:(headImageUtilDefaultOptionBlock)block
{
    if (desc) {
        self.defaultOptionDesc = desc;
    }
    
    if (block) {
        self.defOptionBlock = block;
    }
}

#pragma mark - UIActionSheetDelegate代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    switch (buttonIndex) {
        case 0:
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
            break;
        case 1:
        {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
        case 2:
        {
            if (self.defOptionBlock) {
                self.defOptionBlock();
            }
            return;
        }
            break;
        default:
            return;
            break;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self.currentVC presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate代理方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 状态栏颜色恢复
    [UIApplication sharedApplication].statusBarStyle = _orignStatusBarStyle;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *original_image = [self fixOrientation:[info objectForKey:@"UIImagePickerControllerEditedImage"] ];
    
    //截成正方形
    float minHeight = MIN(original_image.size.height, original_image.size.width);
    CGImageRef cgimg = CGImageCreateWithImageInRect([original_image CGImage], CGRectMake((original_image.size.width-minHeight)/2, (original_image.size.height-minHeight)/2, minHeight, minHeight));
    original_image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    //缩小
    CGSize newSize = CGSizeMake(180, 180);
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [original_image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    original_image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    if (self.callBackBlock) {
        self.callBackBlock(original_image);
        self.callBackBlock = nil;
    }
    
    // 状态栏颜色恢复
    [UIApplication sharedApplication].statusBarStyle = _orignStatusBarStyle;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//修正照片方向
- (UIImage *)fixOrientation:(UIImage *)aImage
{
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

@implementation UIViewController (Utils)
+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+ (UIViewController *)currentViewController
{
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}
@end

