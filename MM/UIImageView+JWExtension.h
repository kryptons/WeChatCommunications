//
//  UIImageView+JWExtension.h
//  百思不得姐
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (JWExtension)

/** 传图片的URL */
- (void)setHeaderURLWithString:(NSString *)url placeholderWithName:(NSString *)name;

/** 直接传图片名 */
- (void)setHeaderWithPictureName:(NSString *)pictureName;

/** 切半径的一半为一个圆 */
- (void)cutRadiusToCircleWithImage:(NSString *)image;

@end