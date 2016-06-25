//
//  MMFriendBookCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMFriendBookCell.h"

@implementation MMFriendBookCell

- (void)awakeFromNib {
    
    self.imgIcon.layer.masksToBounds = YES;
    self.imgIcon.layer.cornerRadius = 8.0f;
}

- (void)setUserInfo:(MMUserInfo *)userInfo {
    
    _userInfo = userInfo;
    self.lblName.text = userInfo.name;
    [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"contact_"]];
}

@end
