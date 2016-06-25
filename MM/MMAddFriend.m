//
//  MMAddFriend.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAddFriend.h"

@implementation MMAddFriend

+ (instancetype)mmAddriendWithDictionary:(NSDictionary *)dict {
    
    MMAddFriend *addFriend = [[MMAddFriend alloc] init];
    addFriend.icon = dict[@"icon"];
    addFriend.title = dict[@"title"];
    addFriend.subTitle = dict[@"subTitle"];
    return addFriend;
}

@end
