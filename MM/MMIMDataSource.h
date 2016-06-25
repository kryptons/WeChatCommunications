//
//  MMIMDataSource.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 单例 */
#define MMDataSource [MMIMDataSource shareInstance]

/**
 *  此类写了一个provider的具体示例，开发者可以根据此类结构实现provider
 *  用户信息和群组信息都要通过回传id请求服务器获取，参考具体实现代码。
 */
@interface MMIMDataSource : NSObject <RCIMUserInfoDataSource, RCIMGroupInfoDataSource, RCIMGroupUserInfoDataSource>

/** 
 * 单例 
 */
+ (MMIMDataSource *)shareInstance;

/**
 *  同步自己的所属群组到融云服务器,修改群组信息后都需要调用同步
 */
- (void)syncGroups;

/**
 *  从服务器同步好友列表
 */
-(void) syncFriendList:(void (^)(NSMutableArray* friends))completion;

/*
 * 当客户端第一次运行时，调用此接口初始化所有用户数据。
 */
- (void)cacheAllData:(void (^)())completion;

/*
 * 获取所有用户信息
 */
- (NSArray *)getAllUserInfo:(void (^)())completion;

/*
 * 获取所有群组信息
 */
- (NSArray *)getAllGroupInfo:(void (^)())completion;

/*
 * 获取所有好友信息
 */
- (NSArray *)getAllFriends:(void (^)())completion;


@end
