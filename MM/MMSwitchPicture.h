//
//  MMSwitchPicture.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSwitchPicture : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *backView;

/** 背景图片 */
@property (strong, nonatomic) UIImageView *backImageView;

/** 图片 */
@property (strong, nonatomic) UIImageView *imageView;

/** 下一张图片 */
@property (assign, nonatomic) NSInteger index;

/** 背景图的下标 */
@property (assign, nonatomic) NSInteger backIndex;

/**
 * 网络图片地址
 */
@property (strong, nonatomic) NSArray *urlArray;

/**
 * 是否循环播放
 */
@property (assign, nonatomic) BOOL isLoop;

/**
 * 播放结束之后的背景图片
 * 如果是循环播放不用设置
 */
@property (strong, nonatomic) NSString *backUrl;

/**
 * 加载数据
 */
- (void)setData;

@end
