//
//  MMSwitchPicture.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMSwitchPicture.h"
#import <SDWebImage/UIImageView+WebCache.h> // SDWebImage

#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width       //屏幕宽
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height      //屏幕高
#define MarginY 40

@implementation MMSwitchPicture

#pragma mark - lazy
- (UIImageView *)backImageView {
    
    if (!_backImageView) {
        
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _backImageView.userInteractionEnabled = YES;
        [self addSubview:_backImageView];
    }
    return _backImageView;
}

- (UIView *)backView {
    
    if (!_backView) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _backView.backgroundColor = [UIColor clearColor];
        [self addSubview:_backView];
    }
    return _backView;
}

#pragma mark - 加载数据
- (void)setData {
    
    self.index = 0;
    self.backIndex = 0;
    // 设置毛玻璃效果
    [self setBlurEffect:self.backImageView alpha:0.8];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[0]]];
    
    for (int i = 0; i < self.urlArray.count - 1; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        // 设置frame
        CGRect frame = imageView.frame;
        frame.size.width = ScreenWidth * 0.8;
        frame.size.height = ScreenHeight * 0.6;
        frame.origin.x = (ScreenWidth - frame.size.width) * 0.5;
        frame.origin.y = MarginY;
        imageView.frame = frame;
        imageView.userInteractionEnabled = YES; // 允许交互
        self.imageView = imageView;
        [self.backView addSubview:imageView];
        [self.backView sendSubviewToBack:imageView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[_index]]];
        
        // 拖拽
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImageView:)];
        pan.delegate = self;
        [imageView addGestureRecognizer:pan];
        self.index++;
    }
}

#pragma mark - 拖拽图片实现
- (void)panImageView:(UIPanGestureRecognizer *)pan {
    
    // 获取手势移动时相对开始的位置
    CGPoint movePoint = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, movePoint.x, movePoint.y);
    // 复位
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        // 使用 UIView 动画使 view 滑行到终点
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            pan.view.center = CGPointMake(-ScreenWidth * 0.5, pan.view.center.y);
            [pan setTranslation:CGPointZero inView:pan.view];
            [self switchBackGroundPicture]; // 切换背景图片
        } completion:^(BOOL finished) {
            
            CGRect frame = pan.view.frame;
            frame.origin.x = (ScreenWidth - frame.size.width) * 0.5;
            frame.origin.y = MarginY;
            pan.view.frame = frame;
            [self.backView sendSubviewToBack:pan.view];
            [self switchPicture:pan.view]; // 切换图片
        }];
    }
    else {
        
        CGPoint point = [pan translationInView:self];
        float pointX = pan.view.center.x + point.x;
        pan.view.center = CGPointMake(pointX, pan.view.center.y);
        [pan setTranslation:CGPointMake(0, 0) inView:pan.view];
    }
}

#pragma mark - 毛玻璃效果
- (void)setBlurEffect:(UIView *)view alpha:(float)alpha {
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.frame;
    blurView.alpha = alpha;
    [view addSubview:blurView];
}

#pragma mark - 切换图片
- (void)switchPicture:(UIView *)view {
    
    UIImageView *imageView = (UIImageView *)view;
    if (!_isLoop && _index == 0) {
        
        [imageView removeFromSuperview];
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_backUrl]];
        return;
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[_index]]];
    if (_index == self.urlArray.count - 1) {
        
        _index = 0;
    }
    else {
        
        _index++;
    }
}

#pragma mark - 切换背景图片
- (void)switchBackGroundPicture {
    
    if (_backIndex == self.urlArray.count - 1) {
        
        _backIndex = 0;
    }
    else {
        _backIndex++;
    }
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.urlArray[_backIndex]]];
}


@end
