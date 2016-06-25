//
//  UIImage+JWExtention.m
//  JWPopMenuDemo
//
//  Created by 陈文昊 on 16/3/30.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "UIImage+JWExtention.h"

@implementation UIImage (JWExtention)

/**
 *  修改图片size
 *
 *  @param image      原图片
 *  @param targetSize 要修改的size
 *
 *  @return 修改后的图片
 */
+ (UIImage *)image:(UIImage *)image byScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect rect = CGRectZero;
    rect.origin = CGPointZero;
    rect.size.width = targetSize.width;
    rect.size.height = targetSize.height;
    
    [sourceImage drawInRect:rect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
