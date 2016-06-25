//
//  MMMineHelper.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMMineHelper.h"

@implementation MMMineHelper


#pragma mark - getMineVCItems设置数据
+ (NSMutableArray *)getMineVCItems {
    
    NSMutableArray *items   = [NSMutableArray array];
    MMSettingItem *album    = [MMSettingItem createWithImageName:@"MoreMyAlbum" title:@"相册"];
    MMSettingItem *favorite = [MMSettingItem createWithImageName:@"MoreMyFavorites" title:@"收藏"];
    MMSettingItem *bank     = [MMSettingItem createWithImageName:@"MoreMyBankCard" title:@"钱包"];
    MMSettingItem *card     = [MMSettingItem createWithImageName:@"MyCardPackageIcon" title:@"卡包"];
    MMSettingGroup *groupOne = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:album, favorite, bank, card, nil];
    [items addObject:groupOne];
    
    MMSettingItem *animation = [MMSettingItem createWithImageName:@"animationExpression" title:@"炫酷动画"];
    MMSettingItem *picture = [MMSettingItem createWithImageName:@"picture" title:@"图片动画"];
    MMSettingGroup *groupTwo = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:animation, picture, nil];
    [items addObject:groupTwo];
    
    MMSettingItem *expression = [MMSettingItem createWithImageName:@"MoreExpressionShops" title:@"表情"];
    MMSettingGroup *groupThree = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:expression, nil];
    [items addObject:groupThree];
    
    MMSettingItem *setting = [MMSettingItem createWithImageName:@"MoreSetting" title:@"设置"];
    MMSettingGroup *groupFour = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:setting, nil];
    [items addObject:groupFour];
    return items;
}

#pragma mark - getMineDetailVCItems设置数据
+ (NSMutableArray *)getMineDetailVCItems:(RCUserInfo *)userInfo {
    
    NSMutableArray *items = [NSMutableArray array];
    MMSettingItem *avatar = [MMSettingItem createWithImageName:nil title:@"头像" subTitle:nil rightImageName:@"publish-gst"];
    MMSettingItem *name = [MMSettingItem createWithTitle:@"昵称" subTitle:userInfo.name];
    MMSettingItem *userID = [MMSettingItem createWithTitle:@"MM号" subTitle:userInfo.userId];
    MMSettingItem *code = [MMSettingItem createWithTitle:@"我的二维码"];
    MMSettingItem *address = [MMSettingItem createWithTitle:@"我的地址"];
    MMSettingGroup *groudOne = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:avatar, name, userID, code, address, nil];
    [items addObject:groudOne];
    
    MMSettingItem *sex = [MMSettingItem createWithTitle:@"性别" subTitle:@"男"];
    MMSettingItem *pos = [MMSettingItem createWithTitle:@"地址" subTitle:@"广州市 天河"];
    MMSettingItem *prover = [MMSettingItem createWithTitle:@"个性签名" subTitle:@"work hard, play hard"];
    MMSettingGroup *groupTwo = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:sex, pos, prover, nil];
    [items addObject:groupTwo];
    return items;
}
#pragma mark - getSettingVCItems设置数据
+ (NSMutableArray *)getSettingVCItems {
    
    NSMutableArray *items = [NSMutableArray array];
    MMSettingItem *safe = [MMSettingItem createWithImageName:nil title:@"账号和安全" middleImageName:@"ProfileLockOn" subTitle:@"已保护"];
    MMSettingGroup *groupOne = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:safe, nil];
    [items addObject:groupOne];
    
    MMSettingItem *not = [MMSettingItem createWithTitle:@"新消息通知"];
    MMSettingItem *privacy = [MMSettingItem createWithTitle:@"隐私"];
    MMSettingItem *normal = [MMSettingItem createWithTitle:@"通用"];
    MMSettingGroup *groupTwo = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:not, privacy, normal, nil];
    [items addObject:groupTwo];
    
    MMSettingItem *feedBack = [MMSettingItem createWithTitle:@"帮助与回馈"];
    MMSettingItem *about = [MMSettingItem createWithTitle:@"关于MM"];
    MMSettingItem *clear = [MMSettingItem createWithTitle:@"清除缓存" subTitle:[NSString getCacheSize]];
    MMSettingGroup *groupThree = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:feedBack, about, clear, nil];
    [items addObject:groupThree];
    
    MMSettingItem *exit = [MMSettingItem createWithTitle:@"退出登录"];
    MMSettingGroup *groupFour = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:nil settingItems:exit, nil];
    [items addObject:groupFour];
    return items;
}

#pragma mark - getNewMessageItems设置数据
+ (NSMutableArray *)getNewMessageItems {
    
    NSMutableArray *items = [NSMutableArray array];
    MMSettingItem *recNoti = [MMSettingItem createWithTitle:@"接受新消息通知" subTitle:@"已开启"];
    MMSettingGroup *groupOne = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:@"如果你要关闭或开启MM的新消息通知，请在iPhone的“设置” - “通知”功能中，找到应用程序“MM”更改。" settingItems:recNoti, nil];
    [items addObject:groupOne];
    
    
    MMSettingItem *showDetail = [MMSettingItem createWithTitle:@"通知显示详情信息"];
    showDetail.type = MMSettingItemTypeSwitch;
    MMSettingGroup *groupTwo = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:@"关闭后，当收到MM消息时，通知提示将不显示发信人和内容摘要。" settingItems:showDetail, nil];
    [items addObject:groupTwo];
    
    MMSettingItem *disturb = [MMSettingItem createWithTitle:@"功能消息免打扰"];
    MMSettingGroup *groupThree = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:@"设置系统功能消息提示声音和振动时段。" settingItems:disturb, nil];
    [items addObject:groupThree];
    
    MMSettingItem *voice = [MMSettingItem createWithTitle:@"声音"];
    voice.type = MMSettingItemTypeSwitch;
    MMSettingItem *shake = [MMSettingItem createWithTitle:@"震动"];
    shake.type = MMSettingItemTypeSwitch;
    MMSettingGroup *groupFour = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:@"当MM在运行时，你可以设置是否需要声音或者振动。" settingItems:voice, shake, nil];
    [items addObject:groupFour];
    
    MMSettingItem *friends = [MMSettingItem createWithTitle:@"朋友圈照片更新"];
    friends.type = MMSettingItemTypeSwitch;
    MMSettingGroup *groupFith = [[MMSettingGroup alloc] initWithHeaderTitle:nil footerTitle:@"关闭后，有朋友更新照片时，界面下面的“发现”切换按钮上不再出现红点提示。" settingItems:friends, nil];
    [items addObject:groupFith];
    return items;
}
@end


























