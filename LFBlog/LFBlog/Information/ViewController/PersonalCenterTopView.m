//
//  PersonalCenterTopView.m
//  SGPageViewExample
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "PersonalCenterTopView.h"
#import "HW3DBannerView.h"

@interface PersonalCenterTopView(){
}
@property (nonatomic,strong) HW3DBannerView *scrollView;
@end

@implementation PersonalCenterTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollView = [HW3DBannerView initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 150) imageSpacing:10 imageWidth:SCREEN_WIDTH - 50];
        _scrollView.initAlpha = 0.5; // 设置两边卡片的透明度
        _scrollView.imageRadius = 10; // 设置卡片圆角
        _scrollView.imageHeightPoor = 10; // 设置中间卡片与两边卡片的高度差
        // 设置要加载的图片
        self.scrollView.data = @[@"http://d.hiphotos.baidu.com/image/pic/item/b7fd5266d016092408d4a5d1dd0735fae7cd3402.jpg",@"http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg"];
        _scrollView.placeHolderImage = [UIImage imageNamed:@""]; // 设置占位图片
        [self addSubview:self.scrollView];
        _scrollView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
            
        };
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [HW3DBannerView initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH,frame.size.height - 30) imageSpacing:20 imageWidth:SCREEN_WIDTH - 120];
        _scrollView.initAlpha = 1; // 设置两边卡片的透明度
        _scrollView.imageRadius = 10; // 设置卡片圆角
        _scrollView.imageHeightPoor = 10; // 设置中间卡片与两边卡片的高度差
        // 设置要加载的图片
        self.scrollView.data = @[@"http://d.hiphotos.baidu.com/image/pic/item/b7fd5266d016092408d4a5d1dd0735fae7cd3402.jpg",@"http://h.hiphotos.baidu.com/image/h%3D300/sign=2b3e022b262eb938f36d7cf2e56085fe/d0c8a786c9177f3e18d0fdc779cf3bc79e3d5617.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/728da9773912b31b57a6e01f8c18367adab4e13a.jpg"];
        _scrollView.placeHolderImage = [UIImage imageNamed:@"placeholder"]; // 设置占位图片
        _scrollView.showPageControl = NO;
        _scrollView.autoScrollTimeInterval = 5.f;
        [self addSubview:self.scrollView];
        _scrollView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
            
        };
    }
    return self;
}

@end
