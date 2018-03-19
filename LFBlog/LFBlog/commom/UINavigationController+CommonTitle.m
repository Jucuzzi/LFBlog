//
//  UINavigationController+CommonTitle.m
//  HEMS
//
//  Created by daiyi on 16/5/20.
//  Copyright © 2016年 杭州天丽科技有限公司. All rights reserved.
//

#import "UINavigationController+CommonTitle.h"
#import "UIImage+Extension.h"

@implementation UINavigationController (CommonTitle)

+ (void)load
{
    ///导航栏图片设置
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageFromColor:[UIColor whiteColor] size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    if (IOS8_OR_LATER) {
        [UINavigationBar appearance].translucent = NO;
    }
//
//    [UINavigationBar appearance].titleTextAttributes = @{
//                                                         NSForegroundColorAttributeName : [UIColor whiteColor],
//                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18.f]
//                                                         };
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
}

@end
