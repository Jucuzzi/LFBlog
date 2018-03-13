//
//  InformationViewController
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonalCenterChildBaseVC.h"

typedef NS_ENUM(NSInteger, HZCommunityInformationType)  {
    HZCommunityInformationType1 = 0,
    HZCommunityInformationType2,
    HZCommunityInformationType3,
    HZCommunityInformationType4,
    HZCommunityInformationType5,
};

@interface InformationViewController : PersonalCenterChildBaseVC

@property (assign,nonatomic) HZCommunityInformationType type;
@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, assign) BOOL isBottom;
@property (nonatomic, assign) BOOL isTop;
@end
