//
//  UIImage+JWExtension.h
//  百思不得姐
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JWExtension)

/**
 *  返回一张圆形的图片
 */
- (instancetype)circleImage;

/**
 *  返回一张圆形的图片
 */

+ (instancetype)circleImageWithName:(NSString *)name;
@end
