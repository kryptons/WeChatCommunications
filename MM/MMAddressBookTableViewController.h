//
//  MMAddressBookTableViewController.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMAddressBookTableViewController : MMBaseViewController

/** 索引 */
@property (strong, nonatomic) NSArray *keys;

/** 所有好友 */
@property (strong, nonatomic) NSMutableDictionary *allFriends;

@property (nonatomic,strong) NSArray *allKeys;

@property (nonatomic,strong) NSArray *seletedUsers;

@property (nonatomic,assign) BOOL hideSectionHeader;

@end
