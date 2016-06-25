//
//  MMGroupCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMGroupCell.h"

@implementation MMGroupCell

- (void)awakeFromNib {

    self.imvGroupPort.layer.masksToBounds = YES;
    self.imvGroupPort.layer.cornerRadius = 8.f;
    self.btJoin.layer.masksToBounds = YES;
    self.btJoin.layer.cornerRadius = 6.f;
}

- (void)setIsJoin:(BOOL)isJoin {
    
    if (isJoin) {
        
        [self.btJoin setImage:[[UIImage imageNamed:@"chat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.btJoin setImage:[[UIImage imageNamed:@"chat_hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateHighlighted];
    }
    else {
        
        [self.btJoin setImage:[[UIImage imageNamed:@"join"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] forState:UIControlStateNormal];
        [self.btJoin setImage:[[UIImage imageNamed:@"join_hover"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
    }
     _isJoin = isJoin;
}

- (void)setGroupInfo:(MMGroupInfo *)groupInfo {
    
    _groupInfo = groupInfo;
    self.lblGroupName.text = groupInfo.groupName;
    self.lblInstru.text = @"群组介绍";
    self.groupID = groupInfo.groupId;
    if (groupInfo.isJoin) {
        
        self.imvGroupPort.image = [[UIImage imageNamed:@"chatroom_icon_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else {
        
        self.imvGroupPort.image = [[UIImage imageNamed:@"chatroom_icon_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    if ([groupInfo.number isEqualToString:@""]) {
        self.lblPersonNumber.text = @"";
    }else{
        self.lblPersonNumber.text = [NSString stringWithFormat:@"%@/%@",groupInfo.number,groupInfo.maxNumber];
    }
}

- (IBAction)btnJoin:(id)sender {
    
    __block typeof(self) weakSelf = self;
    if (!self.isJoin) {
        
        int groupId = [self.groupID intValue];
        NSString *groupName = self.lblGroupName.text;
        [MMHTTPTOOLS joinGroupWithGroupID:groupId withGroupName:groupName complete:^(BOOL result) {
            
            if (_delegate) {
                
                if ([self.delegate respondsToSelector:@selector(joinGroupCallback:withGroupId:)]) {
                    
                    [self.delegate joinGroupCallback:result withGroupId:weakSelf.groupID];
                }
            }
        }];
    }
    else {
        
        if (_delegate) {
            
            if ([self.delegate respondsToSelector:@selector(launchGroupChatPageByGroupId:)]) {
                
                [self.delegate launchGroupChatPageByGroupId:weakSelf.groupID];
            }
        }
    }
}


@end
