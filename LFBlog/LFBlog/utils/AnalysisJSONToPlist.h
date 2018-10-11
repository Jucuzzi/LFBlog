//
//  AnalysisJSONToPlist.h
//  HEMS
//  JSON字符串转plist存文件
//  Created by 沙海瑞 on 12-11-23.
//  Copyright (c) 2012年 沙海瑞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysisJSONToPlist : NSObject

- (void) analysisJSON:(NSString*)json toPlist:(NSString*)fileName;
- (void) analysisDictionary:(NSMutableDictionary*)data toPlist:(NSString*)fileName;

@end
