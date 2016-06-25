//
//  MMFriendCell.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMFriendCell : UITableViewCell
/**
 * 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
/**
 * 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *lblName;
/**
 * 用户模型数据
 */
@property (strong, nonatomic) RCUserInfo *user;

@end
