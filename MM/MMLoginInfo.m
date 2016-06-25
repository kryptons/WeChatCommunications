//
//  MMLoginInfo.m
//  MM
//
//  Created by 陈文昊 on 16/3/28.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMLoginInfo.h"

@implementation MMLoginInfo

+ (id)shareLoginInfo {
    
    static MMLoginInfo *loginInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        loginInfo = [[self alloc] init];
    });
    return loginInfo;
}


@end
