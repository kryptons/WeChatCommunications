//
//  MMIMDataSource.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMIMDataSource.h"

@implementation MMIMDataSource

#pragma mark - 单例
+ (MMIMDataSource *)shareInstance {
    
    static MMIMDataSource *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 同步群组到融云,修改信息需要同步
- (void)syncGroups {
    
    // 开发者调用自己的服务器接口获取所属群组信息，同步给融云服务器，也可以直接
    // 客户端创建，然后同步
    [MMHTTPTOOLS getMyGroupsWithBlock:^(NSMutableArray *result) {
        
        if (result != nil) {
            
            // 同步群组
            [[RCIMClient sharedRCIMClient] syncGroups:result success:^{
                
                NSLog(@"同步群组成功");
            } error:^(RCErrorCode status) {
                NSLog(@"同步群组失败");
            }];
        }
    }];
}

#pragma mark - 从服务器同步好友列表
- (void)syncFriendList:(void (^)(NSMutableArray *))completion {
    
    [MMHTTPTOOLS getFriends:^(NSMutableArray *result) {
        
        completion(result);
    }];
}

#pragma mark - GroupInfoFetcherDelegate
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion {
    
    if (groupId.length == 0) {
        return;
    }
    //开发者调自己的服务器接口根据userID异步请求数据
    [MMHTTPTOOLS getGroupWithGroupID:groupId successCompletion:^(RCGroup *group) {
        completion(group);
    }];
}

#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    
    if (userId == nil || userId.length == 0) {
        
        MMUserInfo *userInfo = [[MMUserInfo alloc] init];
        userInfo.userId = userId;
        userInfo.name = @"";
        userInfo.portraitUri = @"";
        completion(userInfo);
        return;
    }
    // 开发者调自己的服务器接口根据userID异步请求数据
    [MMHTTPTOOLS getUserInfoWithUserID:userId completion:^(RCUserInfo *user) {
        if (user) {
            completion(user);
        }
        else {
            
            RCUserInfo *userInfo = [[RCUserInfo alloc] init];
            userInfo.userId = userId;
            userInfo.name = [NSString stringWithFormat:@"name%@", userId];
            userInfo.portraitUri = @"";
            completion(userInfo);
        }
    }];
}

#pragma mark - RCIMGroupUserInfoDataSource
/**
 *  获取群组内的用户信息。
 *  如果群组内没有设置用户信息，请注意：1，不要调用别的接口返回全局用户信息，直接回调给我们nil就行，SDK会自己巧用用户信息提供者；2一定要调用completion(nil)，这样SDK才能继续往下操作。
 *
 *  @param groupId  群组ID.
 *  @param completion 获取完成调用的BLOCK.
 */
- (void)getUserInfoWithUserId:(NSString *)userId inGroup:(NSString *)groupId completion:(void (^)(RCUserInfo *))completion {
    
    // 在这里查询该group内的群名片信息，如果能查到，调用completion返回。如果查询不到也一定要调用completion(nil)
    if ([groupId isEqualToString:@"22"] && [userId isEqualToString:@"30806"]) {
        completion([[RCUserInfo alloc] initWithUserId:@"30806" name:@"我在22群中的名片" portrait:nil]);
    } else {
        completion(nil);//融云demo中暂时没有实现，以后会添加上该功能。app也可以自己实现该功能。
    }
}

- (void)cacheAllUserInfo:(void (^)())completion {
    
    __block NSArray *regDataArray;
    [MMAFHttpTool getFriendsSuccess:^(id response) {
        if (response) {
            
            NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if ([code isEqualToString:@"200"]) {
                    
                    regDataArray = response[@"result"];
                    for (int i = 0; i < regDataArray.count; i++) {
                        
                        NSDictionary *dict = [regDataArray objectAtIndex:i];
                        RCUserInfo *userInfo = [[RCUserInfo alloc] init];
                        NSNumber *idNum = [dict objectForKey:@"id"];
                        userInfo.userId = [NSString stringWithFormat:@"%d", idNum.intValue];
                        userInfo.name = [dict objectForKey:@"username"];
                        userInfo.portraitUri = [dict objectForKey:@"portrait"];
                        [[MMDataBaseManager shareInstance] insertUserToDB:userInfo];
                    }
                    completion();
                }
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"getUserInfoByUserID error");
    }];
}

- (void)cacheAllGroup:(void (^)())completion {
    
    [MMHTTPTOOLS getAllGroupsWithCompletion:^(NSMutableArray *result) {
        
        [[MMDataBaseManager shareInstance] clearGroupsData];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            for (int i = 0; i < result.count; i++) {
                
                MMGroupInfo *groupInfo = [result objectAtIndex:i];
                [[MMDataBaseManager shareInstance] insertGroupToDB:groupInfo];
            }
        });
    }];
}

- (void)cacheAllFriends:(void (^)())completion
{
    [MMHTTPTOOLS getFriends:^(NSMutableArray *result) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            [[MMDataBaseManager shareInstance] clearFriendsData];
            [result enumerateObjectsUsingBlock:^(MMUserInfo *userInfo, NSUInteger idx, BOOL *stop) {
                MMUserInfo *friend = [[MMUserInfo alloc] initWithUserId:userInfo.userId name:userInfo.name portrait:userInfo.portraitUri];
                [[MMDataBaseManager shareInstance] insertFriendToDB:friend];
            }];
            completion();
        });
    }];
}

- (void)cacheAllData:(void (^)())completion {
    
    __weak MMIMDataSource *weakSelf = self;
    [self cacheAllUserInfo:^{
        [weakSelf cacheAllGroup:^{
            [weakSelf cacheAllFriends:^{
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notFirstTimeLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                completion();
            }];
        }];
    }];
}

/**
 * 获取所有用户信息
 */
- (NSArray *)getAllUserInfo:(void (^)())completion {
    
    NSArray *allUserInfo = [[MMDataBaseManager shareInstance] getAllUserInfo];
    if (!allUserInfo.count) {
        [self cacheAllUserInfo:^{
            completion();
        }];
    }
    return allUserInfo;
}

/*
 * 获取所有群组信息
 */
- (NSArray *)getAllGroupInfo:(void (^)())completion
{
    NSArray *allGroupInfo = [[MMDataBaseManager shareInstance] getAllGroup];
    if (!allGroupInfo.count) {
        [self cacheAllGroup:^{
            completion();
        }];
    }
    return allGroupInfo;
}

/*
 * 获取所有好友信息
 */
- (NSArray *)getAllFriends:(void (^)())completion
{
    NSArray *allFriends = [[MMDataBaseManager shareInstance] getAllFriends];
    if (!allFriends.count) {
        [self cacheAllFriends:^{
            completion();
        }];
    }
    return allFriends;
}

@end
