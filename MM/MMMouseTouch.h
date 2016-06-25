//
//  MMMouseTouch.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMouseTouch : UIView


// 给定一个触摸的位置 在整个屏幕散圆
+ (instancetype)viewWithCicle:(CGRect)rect;

- (instancetype)initWithFrame:(CGRect)frame;


@end
