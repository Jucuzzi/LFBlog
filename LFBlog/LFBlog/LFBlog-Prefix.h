//
//  LFBlog-Prefix.h
//  LFBlog
//
//  Created by 王力丰 on 2018/3/1.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#ifndef LFBlog_Prefix_h
#define LFBlog_Prefix_h
/************************************  颜色定义  ************************************/
#define DEFAULT_BACKGROUND_COLOR  [UIColor colorWithRed:241/255.0 green:243/255.0 blue:245/255.0 alpha:1]
#define DEFAULT_NAVIGATION_COLOR [UIColor colorWithRed:0 green:171/255.0 blue:253/255.0 alpha:1]
#define DEFAULT_BLUE_COLOR  [UIColor colorWithRed:0/255.0 green:171/255.0 blue:253/255.0 alpha:1]

/************************************  宽高定义  ************************************/
#define STATUSBAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define IS_IPHONE_X (SCREEN_HEIGHT == 812.0)
#define NAV_TITLE_HEIGHT 44
#define DEFAULT_HEIGHT (IS_IPHONE_X?SCREEN_HEIGHT-NAV_TITLE_HEIGHT-STATUSBAR_HEIGHT-34:SCREEN_HEIGHT-NAV_TITLE_HEIGHT-STATUSBAR_HEIGHT)

/************************************  服务器  ************************************/
#define LFBlogHttpService @"http://www.jucuzzi.net:8080/HemsCommunity/"
#define LFBlogUserIconPath @"http://www.jucuzzi.net:8080/HemsCommunity/dist/InformationImage_test/"
#endif /* LFBlog_Prefix_h */
