//
//  MMFriendBookCell.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMUserInfo;
@interface MMFriendBookCell : UITableViewCell

@property (strong, nonatomic) MMUserInfo *userInfo;

@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
