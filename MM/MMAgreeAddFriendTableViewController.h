//
//  MMAgreeAddFriendTableViewController.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMAgreeAddFriendTableViewController : MMBaseViewController

/**
 *  targetId
 */
@property (strong, nonatomic) NSString *targetId;

/**
 *  targetName
 */
@property(nonatomic, strong) NSString *userName;
/**
 *  conversationType
 */
@property(nonatomic) RCConversationType conversationType;
/**
 * model
 */
// @property (strong,nonatomic) RCConversationModel *conversation;

/**
 * 初始化
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withConversationModel:(RCConversationModel *)model;

@end
