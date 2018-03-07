//
//  LoginViewController.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , LFBlogType) {
    LFBlogTypeLogin,
    LFBlogTypeRegister,
    LFBlogTypeForget,
};

@interface LoginViewController : UIViewController

@property (nonatomic,assign) LFBlogType type;

@end
