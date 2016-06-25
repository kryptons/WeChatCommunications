//
//  MMHttpTools.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHttpTools.h"
#import<CommonCrypto/CommonDigest.h>

@interface MMAFHttpTool()

@property (nonatomic,strong) NSMutableArray *allFriends;
@property (nonatomic,strong) NSMutableArray *allGroups;

@end
@implementation MMHttpTools

+ (MMHttpTools *)shareInstance {
    
    static MMHttpTools *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[[self class] alloc] init];
        instance.allGroups = [NSMutableArray array];
    });
    return instance;
}

#pragma mark - 获取用户个人基本信息
- (void)getUserInfoWithUserID:(NSString *)userID completion:(void (^)(RCUserInfo *))completion {
    
    MMUserInfo *userInfo = [[MMDataBaseManager shareInstance] getUserByUserId:userID];
    if (userInfo == nil) { // 该用户还没有保存到数据库
        
        [MMAFHttpTool getUserWithUserId:userID success:^(id response) {
            
            if (response) {
                
                NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
                if ([code isEqualToString:@"200"]) {
                    
                    NSDictionary *dict = response[@"result"];
                    MMUserInfo *user = [[MMUserInfo alloc] init];
                    NSNumber *idNum = [dict objectForKey:@"id"];
                    user.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                    user.portraitUri = [dict objectForKey:@"portrait"];
                    user.name = [dict objectForKey:@"username"];
                    [[MMDataBaseManager shareInstance] insertUserToDB:user];
                    if (completion) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            completion(user);
                        });
                    }
                }
                else {
                    
                    MMUserInfo *user = [[MMUserInfo alloc] init];
                    user.userId = userID;
                    user.portraitUri = @"";
                    user.name = [NSString stringWithFormat:@"name%@", userID];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(user);
                    });
                }
            }
        } failure:^(NSError *error) {
            
            NSLog(@"getUserInfoByUserID error");
            if (completion) {
                @try {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        RCUserInfo *user = [RCUserInfo new];
                        
                        user.userId = userID;
                        user.portraitUri = @"";
                        user.name = [NSString stringWithFormat:@"name%@", userID];
                        completion(user);
                    });
                }
                @catch (NSException *exception) {
                    
                }
                @finally {
                    
                }
                
            }
        }];
    }
    else {
        
        if (completion) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                completion(userInfo);
            });
        }
    }
}

#pragma mark - 获取好友列表
- (void)getFriends:(void (^)(NSMutableArray *))friendList {
    
    NSMutableArray *list = [NSMutableArray array];
    [MMAFHttpTool getFriendListFromServerSuccess:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        if (friendList) {
            
            if ([code isEqualToString:@"200"]) {
                
                [_allFriends removeAllObjects];
                NSArray *regDataArray = response[@"result"];
                [[MMDataBaseManager shareInstance] clearFriendsData];
                for(int i = 0;i < regDataArray.count;i++){
                    NSDictionary *dic = [regDataArray objectAtIndex:i];
                    if([[dic objectForKey:@"status"] intValue] != 1)
                        continue;
                    
                    MMUserInfo *userInfo = [[MMUserInfo alloc] init];
                    NSNumber *idNum = [dic objectForKey:@"id"];
                    userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                    userInfo.portraitUri = [dic objectForKey:@"portrait"];
                    userInfo.name = [dic objectForKey:@"username"];
                    userInfo.email = [dic objectForKey:@"email"];
                    userInfo.status = [dic objectForKey:@"status"];
                    [list addObject:userInfo];
                    [_allFriends addObject:userInfo];
                    MMUserInfo *user = [[MMUserInfo alloc] init];
                    user.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                    user.portraitUri = [dic objectForKey:@"portrait"];
                    user.name = [dic objectForKey:@"username"];
                    [[MMDataBaseManager shareInstance] insertUserToDB:user];
                    [[MMDataBaseManager shareInstance] insertFriendToDB:user];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    friendList(list);
                });
            }
            else {
                friendList(list);
            }
        }
    } failure:^(NSError *error) {
        
        if (friendList) {
            NSMutableArray *cacheList=[[NSMutableArray alloc]initWithArray:[[MMDataBaseManager shareInstance] getAllFriends]];
            friendList(cacheList);
        }
    }];
}

#pragma mark - 根据用户名查找好友
- (void)searchFriendListByName:(NSString *)name complete:(void (^)(NSMutableArray *))friendList {
    
    NSMutableArray *list = [NSMutableArray array];
    [MMAFHttpTool searchFriendListByName:name success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if (friendList) {
            
            if ([code isEqualToString:@"200"]) { // 请求成功
                
                NSArray *dataArray = response[@"result"];
                for (int i = 0; i < dataArray.count; i++) {
                    
                    NSDictionary *dict = [dataArray objectAtIndex:i];
                    RCUserInfo *userInfo = [RCUserInfo new];
                    NSNumber *idNum = [dict objectForKey:@"id"];
                    userInfo.userId = [NSString stringWithFormat:@"%d", idNum.intValue];
                    userInfo.name = [dict objectForKey:@"username"];
                    userInfo.portraitUri = [dict objectForKey:@"portrait"];
                    [list addObject:userInfo];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    friendList(list);
                });
            }
        }
    } failure:^(NSError *error) {
        if (friendList) {
            friendList(list);
        }
    }];
}

#pragma mark - 根据Email查找好友
- (void)searchFriendListByEmail:(NSString *)email complete:(void (^)(NSMutableArray *))friendList {
    
    NSMutableArray *list = [NSMutableArray array];
    [MMAFHttpTool searchFriendListByEmail:email success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if (friendList) {
            
            if ([code isEqualToString:@"200"]) {
                
                id result = response[@"result"];
                if([result respondsToSelector:@selector(intValue)]) return ;
                if([result respondsToSelector:@selector(objectForKey:)])
                {
                    MMUserInfo *userInfo = [MMUserInfo new];
                    NSNumber *idNum = [result objectForKey:@"id"];
                    userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                    userInfo.portraitUri = [result objectForKey:@"portrait"];
                    userInfo.name = [result objectForKey:@"username"];
                    [list addObject:userInfo];
                    
                }
                else
                {
                    NSArray * regDataArray = response[@"result"];
                    
                    for(int i = 0;i < regDataArray.count;i++){
                        
                        NSDictionary *dic = [regDataArray objectAtIndex:i];
                        MMUserInfo *userInfo = [MMUserInfo new];
                        NSNumber *idNum = [dic objectForKey:@"id"];
                        userInfo.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                        userInfo.portraitUri = [dic objectForKey:@"portrait"];
                        userInfo.name = [dic objectForKey:@"username"];
                        [list addObject:userInfo];
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    friendList(list);
                });
            }
            else {
                friendList(list);
            }
        }
    } failure:^(NSError *error) {
        
        if (friendList) {
            friendList(list);
        }
    }];
    
}

#pragma mark - 请求加好友
- (void)requestAddFriend:(NSString *)userID complete:(void (^)(BOOL))result {
    
    [MMAFHttpTool requestAddFriend:userID success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        NSLog(@"%@", response);
        if (result) {
            
            if ([code isEqualToString:@"200"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    result(YES);
                });
            }
            else {
                
                result(NO);
            }
        }
        
    } failure:^(NSError *error) {
        if (result) {
            
            result(NO);
        }
    }];
}


#pragma mark - sha1数据校验
- (NSString *) sha1:(NSString *)input {
    
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

#pragma mark - 根据id获取单个群组
- (void)getGroupWithGroupID:(NSString *)groupID successCompletion:(void (^)(RCGroup *group))completion {
    
    RCGroup *groupInfo = [[MMDataBaseManager shareInstance] getGroupByGroupId:groupID];
    if (groupInfo == nil) {
        
        [MMAFHttpTool getGroupWithGroupID:groupID success:^(id response) {
            
            NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
            NSDictionary *result = response[@"result"];
            if (result && [code isEqualToString:@"200"]) {
                MMGroupInfo *group = [[MMGroupInfo alloc] init];
                group.groupId = [result objectForKey:@"id"];
                group.groupName = [result objectForKey:@"name"];
                group.portraitUri = [result objectForKey:@"portrait"];
                if (group.portraitUri) {
                    group.portraitUri = @"";
                }
                group.creatorId = [result objectForKey:@"create_user_id"];
                group.introduce = [result objectForKey:@"introduce"];
                if (group.introduce) {
                    group.introduce = @"";
                }
                group.number = [result objectForKey:@"number"];
                group.maxNumber = [result objectForKey:@"max_number"];
                group.creatorTime = [result objectForKey:@"creat_datetime"];
                [[MMDataBaseManager shareInstance] insertGroupToDB:group];
                if ([group.groupId isEqualToString:groupID] && completion) {
                    completion(group);
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    else {
        
        if (completion) {
            completion(groupInfo);
        }
    }
}

#pragma mark - 获取群组列表
- (void)getAllGroupsWithCompletion:(void (^)(NSMutableArray *result))completion {
    
    [MMAFHttpTool getAllGroupsSuccess:^(id response) {
        
        NSMutableArray *tempArr = [NSMutableArray array];
        NSArray *allGroups = response[@"result"];
        if (allGroups) {
            
            [[MMDataBaseManager shareInstance] clearGroupsData];
            for (NSDictionary *dict in allGroups) {
                MMGroupInfo *group = [[MMGroupInfo alloc] init];
                group.groupId = [dict objectForKey:@"id"];
                group.groupName = [dict objectForKey:@"name"];
                group.portraitUri = [dict objectForKey:@"portrait"];
                if (group.portraitUri) {
                    group.portraitUri = @"";
                }
                group.creatorId = [dict objectForKey:@"create_user_id"];
                group.introduce = [dict objectForKey:@"introduce"];
                if (group.introduce) {
                    group.introduce = @"";
                }
                group.number = [dict objectForKey:@"number"];
                group.maxNumber = [dict objectForKey:@"max_number"];
                group.creatorTime = [dict objectForKey:@"creat_datetime"];
                [[MMDataBaseManager shareInstance] insertGroupToDB:group];
                [tempArr addObject:group];
            }
            
            //获取加入状态
            [self getMyGroupsWithBlock:^(NSMutableArray *result) {
                for (MMGroupInfo *group in result) {
                    for (MMGroupInfo *groupInfo in tempArr) {
                        if ([group.groupId isEqualToString:groupInfo.groupId]) {
                            groupInfo.isJoin = YES;
                            [[MMDataBaseManager shareInstance] insertGroupToDB:groupInfo];
                        }
                        
                    }
                }
                if (completion) {
                    [_allGroups removeAllObjects];
                    [_allGroups addObjectsFromArray:tempArr];
                    
                    completion(tempArr);
                }
                
            }];
        }
    } failure:^(NSError *erro) {
        
        NSMutableArray *cacheGroups = [[NSMutableArray alloc]initWithArray:[[MMDataBaseManager shareInstance] getAllGroup]];
        completion(cacheGroups);
    }];
}

#pragma mark - 获取我的群组
- (void)getMyGroupsWithBlock:(void (^)(NSMutableArray *))block {
    
    [MMAFHttpTool getMyGroupsSuccess:^(id response) {
        
        NSArray *allGroups = response[@"result"];
        NSMutableArray *tempArr = [NSMutableArray array];
        if (allGroups) {
            
            for (NSDictionary *dict in allGroups) {
                
                MMGroupInfo *group = [[MMGroupInfo alloc] init];
                group.groupId = [dict objectForKey:@"id"];
                group.groupName = [dict objectForKey:@"name"];
                group.portraitUri = [dict objectForKey:@"portrait"];
                if (group.portraitUri) {
                    group.portraitUri = @"";
                }
                group.creatorId = [dict objectForKey:@"create_user_id"];
                group.introduce = [dict objectForKey:@"introduce"];
                if (group.introduce) {
                    group.introduce = @"";
                }
                group.number = [dict objectForKey:@"number"];
                if (group.number) {
                    group.number = @"";
                }
                group.maxNumber = [dict objectForKey:@"max_number"];
                if (group.maxNumber) {
                    group.maxNumber = @"";
                }
                [tempArr addObject:group];
                group.isJoin = YES;
                [[MMDataBaseManager shareInstance] insertGroupToDB:group];
            }
            if (block) {
                block(tempArr);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 加入群组
- (void)joinGroupWithGroupID:(int)groupID withGroupName:(NSString *)groupName complete:(void (^)(BOOL))joinResult {
    
    [MMAFHttpTool joinGroupByID:groupID success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        if (joinResult) {
            
            if ([code isEqualToString:@"200"]) {
                
                [[RCIMClient sharedRCIMClient] joinGroup:[NSString stringWithFormat:@"%d", groupID] groupName:groupName success:^{
                    
                    for (MMGroupInfo *groupInfo in _allGroups) {
                        
                        if ([groupInfo.groupId isEqualToString:[NSString stringWithFormat:@"%d",groupID]]) {
                            
                            groupInfo.isJoin = YES;
                            [[MMDataBaseManager shareInstance] insertGroupToDB:groupInfo];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        joinResult(YES);
                    });
                } error:^(RCErrorCode status) {
                    joinResult(NO);
                }];
            }
            else {
                joinResult(NO);
            }
        }
        
    } failure:^(NSError *error) {
        joinResult(NO);
    }];
}

#pragma mark - 创建群组
- (void)createGroupWithGroupName:(NSString *)groupName complete:(void (^)(BOOL))createResult {
    
    [MMAFHttpTool createGroupWithName:groupName success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if (createResult) {
            
            if ([code isEqualToString:@"200"]) {
                
                createResult(YES);
            }
            else {
                
                createResult(NO);
            }
        }
    } failure:^(NSError *error) {
        createResult(NO);
    }];
}

#pragma mark - 退出群组
- (void)quitGroupWithGroupID:(int)groupID complete:(void (^)(BOOL))quitResult {
    
    [MMAFHttpTool quitGroupByID:groupID success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if (quitResult) {
            
            if ([code isEqualToString:@"200"]) {
                
                [[RCIMClient sharedRCIMClient] quitGroup:[NSString stringWithFormat:@"%d", groupID] success:^{
                    
                    quitResult(YES);
                    for (MMGroupInfo *group in _allGroups) {
                        if ([group.groupId isEqualToString:[NSString stringWithFormat:@"%d",groupID]]) {
                            
                            group.isJoin = NO;
                            [[MMDataBaseManager shareInstance] insertGroupToDB:group];
                        }
                    }
                } error:^(RCErrorCode status) {
                    quitResult(NO);
                }];
            }
            else {
                quitResult(NO);
            }
        }
    } failure:^(NSError *error) {
        if (quitResult) {
            quitResult(NO);
        }
    }];
}

#pragma mark - 更新群组
- (void)updateGroupById:(int)groupID withGroupName:(NSString *)groupName andintroduce:(NSString *)introduce complete:(void (^)(BOOL))result {
    
    __block typeof(id) weakGroupId = [NSString stringWithFormat:@"%d", groupID];
    [MMAFHttpTool updateGroupByID:groupID withGroupName:groupName andGroupIntroduce:introduce success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        
        if (result) {
            if ([code isEqualToString:@"200"]) {
                
                for (MMGroupInfo *group in _allGroups) {
                    
                    if ([group.groupId isEqualToString:weakGroupId]) {
                        group.groupName = groupName;
                        group.introduce = introduce;
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    result(YES);
                });
                
            }else{
                result(NO);
            }
            
        }
    } failure:^(id response) {
        if (result) {
            result(NO);
        }
    }];
}

#pragma mark - 删除好友
- (void)deleteFriendWithUseId:(NSString *)userId complete:(void (^)(BOOL))result {
    
    [MMAFHttpTool deleteFriend:userId success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if (result) {
            
            if ([code isEqualToString:@"200"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    result(YES);
                });
                [[MMDataBaseManager shareInstance] deleteFriendFromDB:userId];
            }
            else {
                result(NO);
            }
        }
    } failure:^(NSError *error) {
        
        if (result) {
            result(NO);
        }
    }];
}

#pragma mark - 更新用户昵称
- (void)updateUserName:(NSString *)userName success:(void (^)(id response))success failure:(void (^)(NSError *))failure {
    
    [MMAFHttpTool updateUserName:userName success:^(id response) {
        
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - 更新用户本地数据库
- (void)updateUserInfo:(NSString *)userID success:(void (^)(RCUserInfo *))success failure:(void (^)(NSError *))failure {
    
    [MMAFHttpTool getUserWithUserId:userID success:^(id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        if (response) {
            
            if ([code isEqualToString:@"200"]) {
                
                NSDictionary *dic = response[@"result"];
                RCUserInfo *user = [RCUserInfo new];
                NSNumber *idNum = [dic objectForKey:@"id"];
                user.userId = [NSString stringWithFormat:@"%d",idNum.intValue];
                user.portraitUri = [dic objectForKey:@"portrait"];
                user.name = [dic objectForKey:@"username"];
                [[MMDataBaseManager shareInstance] insertUserToDB:user];
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(user);
                    });
                }
            }
        }
    } failure:^(NSError *error) {
        
        failure(error);
    }];
}

@end
