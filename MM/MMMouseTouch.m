//
//  MMMouseTouch.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMMouseTouch.h"

#define HeightAndWidth 24

@implementation MMMouseTouch

+ (instancetype)viewWithCicle:(CGRect)rect {
    
    return [[self alloc] initWithFrame:rect];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)createLayer:(NSSet *)touches {
    
    // 1、获取点击屏幕的点坐标
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // 2、创建层对象
    CALayer *waveLayer = [CALayer layer];
    
    // 3、设置层的显示位置及大小
    waveLayer.frame = CGRectMake(point.x - 1, point.y - 1, HeightAndWidth, HeightAndWidth);
    // 4、设置层的颜色
    waveLayer.borderColor = [UIColor colorWithRed:(arc4random() % 256 / 255.0) green:(arc4random() % 256 / 255.0) blue:(arc4random() % 256 / 255.0) alpha:1.0].CGColor;
    // 5、设置层的边框宽度
    waveLayer.borderWidth = 0.2;
    // 6、设置层的圆效果
    waveLayer.masksToBounds = YES;
    waveLayer.cornerRadius = HeightAndWidth * 0.5; // 半径圆
    // 7、设置圆的动画效果
    [self setAnimation:waveLayer];
    // 8、将Layer添加到当前层上
    [self.layer addSublayer:waveLayer];
}

#pragma mark - 实现动画效果
- (void)setAnimation:(CALayer *)layer {
    
    const int max = 20;
    if (layer.transform.m11 < max) {
        
        [layer setTransform:CATransform3DScale(layer.transform, 1.1, 1.1, 1.0)];
        //_cmd 获取当前方法的名字
        [self performSelector:_cmd withObject:layer afterDelay:0.03];
    }
    else {
        
        [layer removeFromSuperlayer];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self createLayer:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self createLayer:touches];
}

@end











