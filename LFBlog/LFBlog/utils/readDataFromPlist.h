//
//  readDataFromPlist.h
//  xBike
//
//  Created by 王力丰 on 2017/3/16.
//  Copyright © 2017年 LifengWang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface readDataFromPlist : NSObject

///从指定文件名读取文件转为字典
- (NSMutableDictionary *)readDataFromPlist:(NSString *)filename;

- (id)getValueForKeyFromPList:(NSString *)filename forKey:(NSString *)key;

@end
