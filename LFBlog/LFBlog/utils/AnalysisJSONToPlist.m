//
//  AnalysisJSONToPlist.m
//  HEMS
//  JSON字符串转plist存文件
//  Created by 沙海瑞 on 12-11-23.
//  Copyright (c) 2012年 沙海瑞. All rights reserved.
//

#import "AnalysisJSONToPlist.h"
#import "JSONKit.h"

@implementation AnalysisJSONToPlist

- (void) analysisJSON:(NSString*)json toPlist:(NSString*)fileName{
    NSDictionary *data = [json objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    //第一步：获取document目录。
    //NSSearchPathForDirectoriesInDomains方法用于返回用户资源目录下的目录列表
    
    NSArray *allPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"%@",allPath);
    NSString *documentPath=[allPath objectAtIndex:0];
//    NSLog(@"%@",documentPath);
    //第二步：申明一个需要被写入的文件，并合成完整路径
    //stringByAppendingPathComponent，就是将documentPath和@"fileName.plist"组合起来成为一个新的文件路径
    NSString *file=[documentPath stringByAppendingPathComponent:fileName];
    file = [file stringByAppendingString:@".plist"];
    /*
     补充：上面这个可以改为：
     NSString *fileName=[NSString stringWithFormat:@"%@/properties.plist" documentPath];
     也是一样的
     但是必须要对其进行url格式化，就是：
     NSURL pathUrl=[NSURL FileUrlWithPath:fileName];
     */
    
    //第三步：将数组里面的数据写入到给定的文件里面,并同时写入一个文件到document目录
    //writeToFile：通过给定一个路径写入一个字典文件到文件
    //NSURL *fileUrl=[NSURL fileURLWithPath:fileName];
//    NSLog(@"%@",file);
    [data writeToFile:file atomically:YES];
}

- (void) analysisDictionary:(NSMutableDictionary*)data toPlist:(NSString*)fileName{
    //第一步：获取document目录。
    //NSSearchPathForDirectoriesInDomains方法用于返回用户资源目录下的目录列表
    
    NSArray *allPath=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath=[allPath objectAtIndex:0];
    
    //第二步：申明一个需要被写入的文件，并合成完整路径
    //stringByAppendingPathComponent，就是将documentPath和@"fileName.plist"组合起来成为一个新的文件路径
    NSString *file=[documentPath stringByAppendingPathComponent:fileName];
    file = [file stringByAppendingString:@".plist"];
    /*
     补充：上面这个可以改为：
     NSString *fileName=[NSString stringWithFormat:@"%@/properties.plist" documentPath];
     也是一样的
     但是必须要对其进行url格式化，就是：
     NSURL pathUrl=[NSURL FileUrlWithPath:fileName];
     */
    
    //第三步：将数组里面的数据写入到给定的文件里面,并同时写入一个文件到document目录
    //writeToFile：通过给定一个路径写入一个字典文件到文件
    //NSURL *fileUrl=[NSURL fileURLWithPath:fileName];
//    NSLog(@"%@",file);
    [data writeToFile:file atomically:YES];
}

@end
