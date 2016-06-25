//
//  JWMenu.h
//  JWPopMenuDemo
//
//  Created by 陈文昊 on 16/3/29.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface JWMenuItem : NSObject

@property (readwrite, nonatomic, strong) UIImage *image;
@property (readwrite, nonatomic, strong) NSString *title;
@property (readwrite, nonatomic, weak) id target;
@property (readwrite, nonatomic) SEL action;
@property (readwrite, nonatomic, strong) UIColor *foreColor;
@property (readwrite, nonatomic) NSTextAlignment alignment;

+ (instancetype)menuItem:(NSString *)title image:(UIImage *)image titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

@end

@interface JWMenu : NSObject

+ (void)showMenuInView:(UIView *)view fromRect:(CGRect)rect menuItems:(NSArray *)menuItems viewBackgroundColor:(NSString *)viewBackgroundColor;

+ (void)dismissMenu;

+ (UIColor *)tintColor;

+ (void)setTintColor:(UIColor *)tintColor;

+ (UIFont *)titleFont;

+ (void)setTitleFont:(UIFont *)titleFont;

@end
