//
//  MMAgreeFriendCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAgreeFriendCell.h"

@implementation MMAgreeFriendCell

- (void)awakeFromNib {
    
    self.imgIcon.layer.cornerRadius = 6.0f;
    self.imgIcon.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setMessage:(RCMessage *)message {
    
    _message = message;
    if (![message.content isMemberOfClass:[RCContactNotificationMessage class]]) {
        return;
    }
    RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)message.content;
    self.lblDetail.text = _contactNotificationMsg.message;
    NSDictionary *cacheUserInfo = [[NSUserDefaults standardUserDefaults] objectForKey:_contactNotificationMsg.sourceUserId];
    if (cacheUserInfo) {
        self.lblName.text = cacheUserInfo[@"username"];
        [self.imgIcon sd_setImageWithURL:[NSURL URLWithString:cacheUserInfo[@"portraitUri"]] placeholderImage:[UIImage imageNamed:@"icon_person"]];
    }
    else {
        self.lblName.text = [NSString stringWithFormat:@"user<%@>", _contactNotificationMsg.sourceUserId];
        [self.imgIcon setImage:[UIImage imageNamed:@"icon_person"]];
    }
    
}

@end
