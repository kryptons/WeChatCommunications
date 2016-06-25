//
//  UIImage+Extension.h
//  生成二维码Demo
//
//  Created by GuShengtang on 15-12-2.
//  Copyright (c) 2015年 Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

@end
