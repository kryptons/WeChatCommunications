//
//  MMDataBaseManager.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMDataBaseManager : NSObject

+ (MMDataBaseManager *)shareInstance;

//存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user;

//插入黑名单列表
- (void)insertBlackListToDB:(RCUserInfo *)user;

//获取黑名单列表
- (NSArray *)getBlackList;

//移除黑名单
- (void)removeBlackList:(NSString *)userId;

//清空黑名单缓存信息
-(void)clearBlackListData;

//从表中获取用户信息
-(MMUserInfo *) getUserByUserId:(NSString*)userId;

//从表中获取所有用户信息
-(NSArray *) getAllUserInfo;

//存储群组信息
-(void)insertGroupToDB:(MMGroupInfo *)group;

//从表中获取群组信息
-(MMGroupInfo *)getGroupByGroupId:(NSString*)groupId;

//从表中获取所有群组信息
-(NSArray *) getAllGroup;

//存储好友信息
-(void)insertFriendToDB:(MMUserInfo *)friend;


//清空群组缓存数据
-(void)clearGroupsData;

//清空好友缓存数据
-(void)clearFriendsData;

//从表中获取所有好友信息 //RCUserInfo
-(NSArray *) getAllFriends;

//删除好友信息
-(void)deleteFriendFromDB:(NSString *)userId;

@end
