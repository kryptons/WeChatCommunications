//
//  MMDataBaseManager.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMDataBaseManager.h"
#import "MMLoginInfo.h"
#import "MMGroupInfo.h"
#import "MMUserInfo.h"
#import "MMHttpTools.h"
#import "DBHelper.h"

@implementation MMDataBaseManager

static NSString * const userTableName = @"USERTABLE";
static NSString * const groupTableName = @"GROUPTABLEV2";
static NSString * const friendTableName = @"FRIENDTABLE";
static NSString * const blackTableName = @"BLACKTABLE";

+ (MMDataBaseManager *)shareInstance {
    
    static MMDataBaseManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
        [instance createUserTable];
    });
    return instance;
}

#pragma mark - 创建用户存储表
- (void)createUserTable {
    
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue == nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        
        if (![DBHelper isTableOK:userTableName withDB:db]) {
            
            NSString *createTableSQL = @"CREATE TABLE USERTABLE (id integer PRIMARY KEY autoincrement, userid text,name text, portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_userid ON USERTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![DBHelper isTableOK: groupTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE GROUPTABLEV2 (id integer PRIMARY KEY autoincrement, groupId text,name text, portraitUri text,inNumber text,maxNumber text ,introduce text ,creatorId text,creatorTime text, isJoin text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_groupid ON GROUPTABLEV2(groupId);";
            [db executeUpdate:createIndexSQL];
        }
        if (![DBHelper isTableOK: friendTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE FRIENDTABLE (id integer PRIMARY KEY autoincrement, userid text,name text, portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_friendId ON FRIENDTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
        if (![DBHelper isTableOK: blackTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE BLACKTABLE (id integer PRIMARY KEY autoincrement, userid text,name text, portraitUri text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL = @"CREATE unique INDEX idx_blackId ON BLACKTABLE(userid);";
            [db executeUpdate:createIndexSQL];
        }

    }];
    
}

#pragma mark - 存储用户信息
- (void)insertUserToDB:(RCUserInfo *)user {
    
    NSString *insertSql = @"REPLACE INTO USERTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,user.userId,user.name,user.portraitUri];
    }];
}

#pragma mark - 插入黑名单列表
- (void)insertBlackListToDB:(RCUserInfo *)user {
    
    NSString *insertSql = @"REPLACE INTO BLACKTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,user.userId,user.name,user.portraitUri];
    }];
}

#pragma mark - 获取黑名单列表
- (NSArray *)getBlackList {
    
    NSMutableArray *allBlackList = [NSMutableArray array];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM BLACKTABLE"];
        while ([resultSet next]) {
            
            RCUserInfo *model = [[RCUserInfo alloc] init];
            model.userId = [resultSet stringForColumn:@"userid"];
            model.name = [resultSet stringForColumn:@"name"];
            model.portraitUri = [resultSet stringForColumn:@"portraitUri"];
            [allBlackList addObject:model];
        }
        [resultSet close];
    }];
    return allBlackList;
}

#pragma mark - 移除黑名单
- (void)removeBlackList:(NSString *)userId {
    
    NSString *deleteSql = [NSString stringWithFormat: @"DELETE FROM BLACKTABLE WHERE userid=%@",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue == nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

#pragma mark - 清空黑名单缓存数据
- (void)clearBlackListData {
    
    NSString *deleteSql = @"DELETE FROM BLACKTABLE";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

#pragma mark - 从表中获取用户信息
- (MMUserInfo *)getUserByUserId:(NSString *)userId {
    
    __block MMUserInfo *model = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue == nil) {
        return nil;
    }
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM USERTABLE where userid = ?",userId];
        while ([resultSet next]) {
            
            model = [[MMUserInfo alloc] init];
            model.userId = [resultSet stringForColumn:@"userid"];
            model.name = [resultSet stringForColumn:@"name"];
            model.portraitUri = [resultSet stringForColumn:@"portraitUri"];
        }
        [resultSet close];
    }];
    return model;
}

#pragma mark - 从表中获取所有用户的信息
- (NSArray *)getAllUserInfo {
    
    NSMutableArray *allUsers = [NSMutableArray array];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM USERTABLE"];
        while ([rs next]) {
            RCUserInfo *model;
            model = [[RCUserInfo alloc] init];
            model.userId = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

#pragma mark - 存储群组信息
- (void)insertGroupToDB:(MMGroupInfo *)group {
    
    if(group == nil || [group.groupId length]<1)
        return;
    
    NSString *insertSql = @"REPLACE INTO GROUPTABLEV2 (groupId, name,portraitUri,inNumber,maxNumber,introduce,creatorId,creatorTime,isJoin) VALUES (?,?,?,?,?,?,?,?,?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:insertSql,group.groupId, group.groupName,group.portraitUri,group.number,group.maxNumber,group.introduce,group.creatorId,group.creatorTime,[NSString stringWithFormat:@"%d",group.isJoin]];
    }];
}

#pragma mark - 从表中获取群组信息
- (MMGroupInfo *)getGroupByGroupId:(NSString *)groupId {
    
    __block MMGroupInfo *model = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM GROUPTABLEV2 where groupId = ?",groupId];
        while ([resultSet next]) {
            
            model = [[MMGroupInfo alloc] init];
            model.groupId = [resultSet stringForColumn:@"groupId"];
            model.groupName = [resultSet stringForColumn:@"name"];
            model.portraitUri = [resultSet stringForColumn:@"portraitUri"];
            model.number = [resultSet stringForColumn:@"inNumber"];
            model.maxNumber = [resultSet stringForColumn:@"maxNumber"];
            model.introduce = [resultSet stringForColumn:@"introduce"];
            model.creatorId = [resultSet stringForColumn:@"creatorId"];
            model.creatorTime = [resultSet stringForColumn:@"creatorTime"];
            model.isJoin = [resultSet boolForColumn:@"isJoin"];
        }
        [resultSet close];
    }];
    return model;
}

#pragma mark - 从表中获取所有群组信息
-(NSArray *) getAllGroup
{
    NSMutableArray *allUsers = [NSMutableArray new];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM GROUPTABLEV2 ORDER BY groupId"];
        while ([rs next]) {
            
            MMGroupInfo *model = [[MMGroupInfo alloc] init];
            model.groupId = [rs stringForColumn:@"groupId"];
            model.groupName = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.number=[rs stringForColumn:@"inNumber"];
            model.maxNumber=[rs stringForColumn:@"maxNumber"];
            model.introduce=[rs stringForColumn:@"introduce"];
            model.creatorId=[rs stringForColumn:@"creatorId"];
            model.creatorTime=[rs stringForColumn:@"creatorTime"];
            model.isJoin=[rs boolForColumn:@"isJoin"];
            [allUsers addObject:model];
        }
        [rs close];
    }];
    return allUsers;
}

#pragma mark - 存储好友信息
- (void)insertFriendToDB:(MMUserInfo *)friend {
    
    NSString *insertSql = @"REPLACE INTO FRIENDTABLE (userid, name, portraitUri) VALUES (?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:insertSql,friend.userId, friend.name, friend.portraitUri];
    }];
}

#pragma mark - 从表中获取所有好友信息
- (NSArray *)getAllFriends {
    
    NSMutableArray *allUsers = [NSMutableArray array];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM FRIENDTABLE"];
        while ([resultSet next]) {
            
            MMUserInfo *model = [[MMUserInfo alloc] init];
            model.userId = [resultSet stringForColumn:@"userid"];
            model.name = [resultSet stringForColumn:@"name"];
            model.portraitUri = [resultSet stringForColumn:@"portraitUri"];
            [allUsers addObject:model];
        }
        [resultSet close];
    }];
    return allUsers;
}

#pragma mark - 清空群组缓存数据
- (void)clearGroupsData {
    
    NSString *deleteSql = @"DELETE FROM GROUPTABLEV2";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue == nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//清空好友缓存数据
-(void)clearFriendsData
{
    NSString *deleteSql = @"DELETE FROM FRIENDTABLE";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}


-(void)deleteFriendFromDB:(NSString *)userId;
{
    NSString *deleteSql =[NSString stringWithFormat: @"DELETE FROM FRIENDTABLE WHERE userid=%@",userId];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

@end
