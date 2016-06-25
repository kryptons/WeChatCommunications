//
//  MMAFHttpTool.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestMethodType){
    RequestMethodTypePost = 1,
    RequestMethodTypeGet = 2
};

@interface MMAFHttpTool : NSObject

/**
 *  发送一个请求
 *
 *  @param methodType   请求方法
 *  @param url          请求路径
 *  @param params       请求参数
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */
+(void) requestWihtMethod:(RequestMethodType)methodType
                     url : (NSString *)url
                   params:(NSDictionary *)params
                  success:(void (^)(id response))success
                  failure:(void (^)(NSError *err))failure;

/** 
 * 获取用户信息 
 */
+ (void)getUserWithUserId:(NSString *)userId success:(void (^)(id response))success failure:(void (^)(NSError* error))failure;

/** 
 * 获取好友列表
 */
+ (void)getFriendListFromServerSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 * 根据ID获取群组信息
 */
+ (void)getGroupWithGroupID:(NSString *)groupID success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/** 
 * 获取好友信息
 */
+ (void)getFriendsSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 * 注册新用户
 */
+ (void)registerWithEmail:(NSString *)email withMobile:(NSString *)mobile withUsername:(NSString *)username withPassword:(NSString *)password success:(void (^)(id response))success failure:(void (^)(NSError* err))failure;

/** 
 * 按昵称搜索好友 
 */
+ (void)searchFriendListByName:(NSString *)name success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 * 按Email搜索好友
 */
+ (void)searchFriendListByEmail:(NSString *)email success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/** 
 * 根据Email登录 
 */
+ (void)loginWithEmail:(NSString *)email withPassword:(NSString *)password env:(NSString *)env success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 * 请求加好友
 */
+ (void)requestAddFriend:(NSString *)userID success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

/**
 * 处理请求加好友
 */
+ (void)requestAgreeToAddFriendWithUserID:(NSString *)userID withIsAccess:(BOOL)isAccess success:(void (^)(id response))success
                                  failure:(void (^)(NSError* err))failure;

#pragma mark - 群组
/**
 * 获取所有群组信息
 */
+ (void)getAllGroupsSuccess:(void (^)(id response))success
                    failure:(void (^)(NSError* error))failure;

/**
 * 获取我的群组信息
 */
+ (void)getMyGroupsSuccess:(void (^)(id response))success
                   failure:(void (^)(NSError* error))failure;

// get group by id
+ (void)getGroupByID:(NSString *) groupID
             success:(void (^)(id response))success
             failure:(void (^)(NSError* error))failure;

// create group
+ (void)createGroupWithName:(NSString *) name
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* error))failure;

// join group
+ (void)joinGroupByID:(int) groupID
              success:(void (^)(id response))success
              failure:(void (^)(NSError* error))failure;

// quit group
+ (void)quitGroupByID:(int) groupID
              success:(void (^)(id response))success
              failure:(void (^)(NSError* error))failure;

// update group
+ (void)updateGroupByID:(int) groupID withGroupName:(NSString*) groupName andGroupIntroduce:(NSString*) introduce
                success:(void (^)(id response))success
                failure:(void (^)(NSError* error))failure;

// 删除好友
+ (void)deleteFriend:(NSString *)userId
             success:(void (^)(id response))success
             failure:(void (^)(NSError *error))failure;

// 更新用户昵称
+ (void)updateUserName:(NSString *)userName
               success:(void (^)(id response))success
               failure:(void (^)(NSError *error))failure;


@end
