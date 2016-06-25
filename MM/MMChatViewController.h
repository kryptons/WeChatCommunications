//
//  MMChatViewController.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface MMChatViewController : RCConversationViewController

/** 会话数据模型 */
@property (strong, nonatomic) RCConversationModel *conversation;

@end
