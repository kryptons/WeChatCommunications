//
//  MMAFHttpTool.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAFHttpTool.h"

#define FAKE_SERVER @"http://webim.demo.rong.io/"//@"http://119.254.110.241:80/" //Login 线下测试
#define ContentType @"text/html"

@implementation MMAFHttpTool

+ (void)requestWihtMethod:(RequestMethodType)methodType url:(NSString *)url params:(NSDictionary *)params success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    NSURL *baseURL = [NSURL URLWithString:FAKE_SERVER];
    // 获得请求管理者
    AFHTTPRequestOperationManager *manage = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
#ifdef ContentType
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObject:ContentType];
#endif
    manage.requestSerializer.HTTPShouldHandleCookies = YES;
    NSString *cookieString = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCookies"];
    if (cookieString) {
        [manage.requestSerializer setValue:cookieString forHTTPHeaderField:@"Cookie"];
    }
    
    switch (methodType) {
        case RequestMethodTypeGet:
        {
            // GET请求
            [manage GET:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                if (success) {
    
                    success(responseObject);
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case RequestMethodTypePost:
        {
            // POST请求
            [manage POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                if (success) {
                    
                    NSString *cookieString = [[operation.response allHeaderFields] valueForKey:@"Set-Cookie"];
                    [[NSUserDefaults standardUserDefaults] setObject:cookieString forKey:@"UserCookies"];
                    success(responseObject);
                }
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 获取用户信息
+ (void)getUserWithUserId:(NSString *)userId success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"profile"
                             params:@{@"id" : userId}
                            success:success
                            failure:failure];
}

#pragma mark - 获取好友列表
+ (void)getFriendListFromServerSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    //获取除自己之外的好友信息
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"get_friend"
                             params:nil
                            success:success
                            failure:failure];
}

#pragma mark - 根据ID获取群组信息
+ (void)getGroupWithGroupID:(NSString *)groupID success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"get_group"
                             params:@{@"id" : groupID}
                            success:success
                            failure:failure];
}

#pragma mark - 获取好友信息
+ (void)getFriendsSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    // 获取包含自己在内的全部注册用户数据
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"friends"
                             params:nil
                            success:success
                            failure:failure];
}

#pragma mark - 注册新用户
+ (void)registerWithEmail:(NSString *)email withMobile:(NSString *)mobile withUsername:(NSString *)username withPassword:(NSString *)password success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSDictionary *params = @{@"email" : email,
                             @"mobile" : mobile,
                             @"username" : username,
                             @"password" : password};
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                                url:@"reg"
                             params:params
                            success:success
                            failure:failure];
}


#pragma mark - 根据昵称搜索好友
+ (void)searchFriendListByName:(NSString *)name success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"seach_name"
                             params:@{@"username" : name}
                            success:success
                            failure:failure];
}

#pragma mark - 根据email搜索好友
+ (void)searchFriendListByEmail:(NSString *)email success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"seach_email"
                             params:@{@"email":email}
                            success:success
                            failure:failure];
}

#pragma mark - 用Email进行登录
+ (void)loginWithEmail:(NSString *)email withPassword:(NSString *)password env:(NSString *)env success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:password forKey:@"password"];
    [params setObject:env forKey:@"env"];
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                                url:@"email_login_token"
                             params:params
                            success:success
                            failure:failure];
}

#pragma mark - 请求加好友
+ (void)requestAddFriend:(NSString *)userID success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                                url:@"request_friend"
                             params:@{@"id":userID, @"message": NSLocalizedStringFromTable(@"Request_Friends_extra", @"RongCloudKit", nil)}
                            success:success
                            failure:failure];
}

#pragma mark - 处理请求加好友
+ (void)requestAgreeToAddFriendWithUserID:(NSString *)userID withIsAccess:(BOOL)isAccess success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSString *isAcept = isAccess ? @"1" : @"0";
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                                url:@"process_request_friend"
                             params:@{@"id":userID,@"is_access":isAcept}
                            success:success
                            failure:failure];
}

#pragma mark - 获取所有群组信息
+ (void)getAllGroupsSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"get_all_group"
                             params:nil
                            success:success
                            failure:failure];
}

#pragma mark - 获取用户群组信息
+ (void)getMyGroupsSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                                url:@"get_my_group"
                             params:nil
                            success:success
                            failure:failure];
}

// get group by id
+ (void)getGroupByID:(NSString *) groupID
             success:(void (^)(id response))success
             failure:(void (^)(NSError* err))failure
{
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"get_group"
                           params:@{@"id":groupID}
                          success:success
                          failure:failure];
    
}

// create group
+ (void)createGroupWithName:(NSString *) name
                    success:(void (^)(id response))success
                    failure:(void (^)(NSError* err))failure
{
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"create_group"
                           params:@{@"name":name}
                          success:success
                          failure:failure];
}

//join group
+ (void)joinGroupByID:(int) groupID
              success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure
{
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"join_group"
                           params:@{@"id":[NSNumber numberWithInt:groupID]}
                          success:success
                          failure:failure];
}

// quit group
+ (void)quitGroupByID:(int) groupID
              success:(void (^)(id response))success
              failure:(void (^)(NSError* err))failure
{
    [MMAFHttpTool requestWihtMethod:RequestMethodTypeGet
                              url:@"quit_group"
                           params:@{@"id":[NSNumber numberWithInt:groupID]}
                          success:success
                          failure:failure];
}


+ (void)updateGroupByID:(int)groupID
         withGroupName:(NSString *)groupName
     andGroupIntroduce:(NSString *)introduce
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure
{
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                              url:@"update_group"
                           params:@{@"id":[NSNumber numberWithInt:groupID],@"name":groupName,@"introduce":introduce}
                          success:success
                          failure:failure];
}

#pragma mark - 删除好友
+ (void)deleteFriend:(NSString *)userId success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                                url:@"delete_friend"
                             params:@{@"id" : userId}
                            success:success
                            failure:failure];
}

#pragma mark - 更新用户昵称
+ (void)updateUserName:(NSString *)userName success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    [MMAFHttpTool requestWihtMethod:RequestMethodTypePost
                                url:@"update_profile"
                             params:@{@"username" : userName}
                            success:success
                            failure:failure];
}


@end
