//
//  MMRequestBLL.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMRequestBLL.h"

#define baseURL @"https://api.cn.ronghub.com/user/getToken.json"

@interface MMRequestBLL()


@end

@implementation MMRequestBLL

+ (MMRequestBLL *)shareInstance {
    
    static MMRequestBLL *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (void)requestGetUserTokenIDWithUserID:(NSString *)userID withUserName:(NSString *)userName success:(void (^)(NSMutableDictionary *))success fail:(void (^)(NSError *))fail {
    
}

@end
