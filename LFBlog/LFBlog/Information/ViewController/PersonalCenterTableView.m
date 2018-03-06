//
//  PersonalCenterTableView.m
//  SGPageViewExample
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "PersonalCenterTableView.h"

@implementation PersonalCenterTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGFloat currentY = [recognizer translationInView:self].y;
        CGFloat currentX = [recognizer translationInView:self].x;
        //判断如果横向移动了，那么纵向就不可以移动了
        if (currentY == 0.0) {
            return YES;
        } else {
            if (fabs(currentX)>3) {
                return NO;
            } else {
                return YES;
            }
        }
    }
    return NO;
}

@end
