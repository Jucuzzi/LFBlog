//
//  SingleTon.m
//  LFBlog
//
//  Created by 王力丰 on 2018/3/5.
//  Copyright © 2018年 LiFeng Wang. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton


static Singleton *sharedSingleton = nil;

+ (Singleton *)sharedSingleton
{
    
    @synchronized(self)
    {
        if (sharedSingleton == nil)
        {
            sharedSingleton = [[self alloc] init];
        }
    }
    return sharedSingleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedSingleton == nil)
        {
            sharedSingleton = [super allocWithZone:zone];
            return sharedSingleton;
        }
    }  
    return nil;
}


@end
