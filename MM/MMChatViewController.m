//
//  MMChatViewController.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMChatViewController.h"

@interface MMChatViewController ()

@end

@implementation MMChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置头像类型(圆角，默认是矩形边角)
    // [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    self.enableContinuousReadUnreadVoice = YES;
    self.enableSaveNewPhotoToLocalSystem = YES;
}


@end
