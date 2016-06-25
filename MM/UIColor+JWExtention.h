//
//  UIColor+JWExtention.h
//  JWPopMenuDemo
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JWExtention)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

// UIColor转UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
