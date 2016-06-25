//
//  MMHttpTools.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MMHTTPTOOLS [MMHttpTools shareInstance]

@interface MMHttpTools : NSObject

/** 
 * 所有好友 
 */
@property (strong, nonatomic) NSMutableArray *allFriends;

/** 
 * 所有群组 
 */
@property (strong, nonatomic) NSMutableArray *allGroups;

/** 
 * MMHttpTools单例 
 */
+ (MMHttpTools *)shareInstance;

/** 
 * 获取用户个人信息 
 */
- (void)getUserInfoWithUserID:(NSString *)userID
                   completion:(void (^)(RCUserInfo *user))completion;

/** 
 * 获取好友列表
 */
- (void)getFriends:(void (^)(NSMutableArray *result))friendList;

/** 
 * 按昵称搜索好友 
 */
- (void)searchFriendListByName:(NSString *)name
                      complete:(void (^)(NSMutableArray *result))friendList;
/** 
 * 按邮箱搜索好友 
 */
- (void)searchFriendListByEmail:(NSString *)email
                       complete:(void (^)(NSMutableArray *result))friendList;

/**
 * 请求加好友
 */
- (void)requestAddFriend:(NSString *)userID complete:(void (^)(BOOL result))result;

/** 
 * sha1数据校验 
 */
- (NSString *)sha1:(NSString *)input;

/**
 * 根据id获取单个群组
 */
- (void)getGroupWithGroupID:(NSString *)groupID successCompletion:(void (^)(RCGroup *group))completion;

/**
 * 获取群组列表
 */
- (void)getAllGroupsWithCompletion:(void (^)(NSMutableArray *result))completion;

/**
 * 获取我的群组
 */
- (void)getMyGroupsWithBlock:(void (^)(NSMutableArray *result))block;

/**
 * 加入群组
 */
- (void)joinGroupWithGroupID:(int) groupID
    withGroupName:(NSString *)groupName
         complete:(void (^)(BOOL result))joinResult;

/**
 * 创建群组
 */
- (void)createGroupWithGroupName:(NSString *)groupName complete:(void (^)(BOOL result))createResult;

/**
 * 退出群组
 */
- (void)quitGroupWithGroupID:(int) groupID
         complete:(void (^)(BOOL result))quitResult;

/**
 * 更新群组信息
 */
- (void)updateGroupById:(int) groupID
         withGroupName:(NSString*)groupName
          andintroduce:(NSString*)introduce
              complete:(void (^)(BOOL result))result;
/**
 * 删除好友
 */
- (void)deleteFriendWithUseId:(NSString *)userId
            complete:(void (^)(BOOL result))result;

/** 
 * 更新用户的昵称
 */
- (void)updateUserName:(NSString *)userName
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure;

//从demo server 获取用户的信息，更新本地数据库
- (void)updateUserInfo:(NSString *) userID
               success:(void (^)(RCUserInfo * user))success
               failure:(void (^)(NSError* err))failure;


@end
