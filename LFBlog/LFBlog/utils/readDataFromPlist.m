//
//  readDataFromPlist.m
//  xBike
//
//  Created by 王力丰 on 2017/3/16.
//  Copyright © 2017年 LifengWang. All rights reserved.
//

#import "readDataFromPlist.h"

@implementation readDataFromPlist

- (NSMutableDictionary *)readDataFromPlist:(NSString *) fileName
{
    NSArray *allPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [allPath objectAtIndex:0];
    NSString *file = [documentPath stringByAppendingPathComponent:fileName];
    file = [file stringByAppendingString:@".plist"];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:file];
    
    return data;
}

- (id)getValueForKeyFromPList:(NSString *)filename forKey:(NSString *)key
{
    NSMutableDictionary * data = [self readDataFromPlist:filename];
    id privateKey;
    if(data){
        privateKey = [data objectForKey:key];
    }
    return privateKey;
}

@end
