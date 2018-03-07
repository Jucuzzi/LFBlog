//
//  LFUser.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/5.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "LFUser.h"

static LFUser *_user = nil;

#define GET_USERNAME                    [[[readDataFromPlist alloc] init] getValueForKeyFromPList:@"userInfo" forKey:@"username"]

/** 通知类型 */
NSString *const UserPhotoDidChangeNotification = @"userPhotoDidChange";             // 用户头像已经变更
NSString *const UserNickNameDidChangeNotification = @"userNickNameDidChange";       // 用户昵称已经变更
/** 文件名称 */
NSString *const UserPhotoIdFileName = @"userPhotoId.plist";                         // 用户头像图片id文件名
NSString *const UserNickNameFileName = @"userNickName.plist";                       // 用户昵称文件名


@interface LFUser ()
{
    NSString *_nickName;
}
@end

@implementation LFUser
+ (instancetype)sharedUser {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _user = [[self alloc] init];
    });
    return _user;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _user = [super allocWithZone:zone];
    });
    return _user;
}

- (id)copyWithZone:(NSZone *)zone {
    return _user;
}

/**
 * 检查头像是否需要更新
 */
- (void)checkLatestUserPic            // 用户头像路径应该独立分隔存放
{
    // 0、判断该用户是否设置过头像
    if ([_userPhotoId isEqual:@""] || (_userPhotoId == nil)) {
        return;
    }
    
    // 1、判断id是否与原有id相同
    // 1.1、获取原有头像id
    NSDictionary    *userPhotoDic = [NSDictionary dictionaryWithContentsOfFile:[[self userDataPath] stringByAppendingPathComponent:UserPhotoIdFileName]];
    NSString        *userPhotoId = userPhotoDic[@"userPhotoId"]; // 用户已存在头像
    
    if ([userPhotoId isEqual:_userPhotoId]) {
        return;
    }
    
    // 2、如果id不相同，进行下图
    [self downloadNewUserPhonto];
}

// 用户头像路径
- (NSString *)userDataPath {
//    NSString    *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
////    NSString    *userPhotoPath = [cachePath stringByAppendingPathComponent:[Singleton sharedSingleton].userId];
//    // 获取路径后如果没有该文件夹则创建
//    NSFileManager   *fileManager = [NSFileManager defaultManager];
//    BOOL            isDir = NO;
//    BOOL            existed = [fileManager fileExistsAtPath:userPhotoPath isDirectory:&isDir];
//
//    if (!((isDir == YES) && (existed == YES))) {
//        [fileManager createDirectoryAtPath:userPhotoPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//
//    return userPhotoPath;
    return @"";
}

/**
 * 下载最新图片
 */
- (void)downloadNewUserPhonto {
//    if (_request.isExecuting) {
//        [_request clearDelegatesAndCancel];
//    }
//
//    NSMutableDictionary *jsonPara = [NSMutableDictionary dictionaryWithCapacity:1];
//    [jsonPara setObject:@"500002" forKey:@"msgType"];
//    ///调用queryMsg方法
//    [jsonPara setObject:@"usersGetUserPhoto" forKey:@"methodName"];
//    [jsonPara setObject:@{@"userIds":[Singleton sharedSingleton].userId} forKey:@"parameter"];
//
//    ///当前时间
//    readDataFromPlist   *readData = [[readDataFromPlist alloc] init];
//    NSString            *uuid = [readData getValueForKeyFromPList:@"uuid" forKey:@"uuid"];
//    NSString            *uuidtime = [readData getValueForKeyFromPList:@"uuidtime" forKey:@"uuidtime"];
//    NSMutableString     *currentTime = [[NSMutableString alloc] initWithCapacity:1];
//    [currentTime appendString:uuid];
//    [currentTime appendString:uuidtime];
//    UpdateUUID
//    ///md5加密
//    HttpUtil    *httpUtil = [[HttpUtil alloc] init];
//    NSString    *mad5Result = [httpUtil packageMad5Result:currentTime jsonParameter:jsonPara privateKey:[Singleton sharedSingleton].privateKey];
//    ///获得url
//    NSString    *cloudUrl = [httpUtil getUrl:[Singleton sharedSingleton].userId encryptionType:@"3" jsonParameter:[NSString changeStringWithASCII:[NSString jsonStringWithObject:jsonPara]] hmac:mad5Result uuid:currentTime];
//    NSURL       *url = [NSURL URLWithString:cloudUrl];
//    _request = [ASIHTTPRequest requestWithURL:url];
//    _request.tag = kDownloadNewUserPhonto_tag;
//    [_request setTimeOutSeconds:15];
//    [_request setDelegate:self];
//    [_request startAsynchronous];
}


@end
