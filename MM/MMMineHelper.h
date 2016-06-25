//
//  MMMineHelper.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMMineHelper : NSObject

+ (NSMutableArray *)getMineDetailVCItems:(RCUserInfo *)userInfo;

+ (NSMutableArray *)getMineVCItems;

+ (NSMutableArray *)getSettingVCItems;

+ (NSMutableArray *)getNewMessageItems;

@end
