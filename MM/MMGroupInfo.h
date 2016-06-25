//
//  MMGroupInfo.h
//  MM
//
//  Created by 陈文昊 on 16/3/28.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMGroupInfo : RCGroup <NSCoding>

/** 人数 */
@property(nonatomic, strong) NSString* number;
/** 最大人数 */
@property(nonatomic, strong) NSString* maxNumber;
/** 群简介 */
@property(nonatomic, strong) NSString* introduce;
/** 创建者Id */
@property(nonatomic, strong) NSString* creatorId;
/** 创建日期 */
@property(nonatomic, strong) NSString* creatorTime;
/** 是否加入 */
@property(nonatomic, assign) BOOL  isJoin;

@end
