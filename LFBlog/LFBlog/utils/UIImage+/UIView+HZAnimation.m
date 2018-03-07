//
//  UIView+HZAnimation.m
//  HEMS
//
//  Created by daiyi on 16/5/18.
//  Copyright © 2016年 杭州天丽科技有限公司. All rights reserved.
//

#import "UIView+HZAnimation.h"

@implementation UIView (HZAnimation)

///摇动画
- (void)shakeAnimationForView
{
    CALayer *viewLayer = self.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 8, position.y);
    CGPoint y = CGPointMake(position.x - 8, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

@end
