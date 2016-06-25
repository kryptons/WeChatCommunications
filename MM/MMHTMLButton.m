//
//  MMHTMLButton.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHTMLButton.h"


@implementation MMHTMLButton

// 设置按钮基本属性
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 设置字体颜色，居中
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置button的背景颜色
        [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 设置imageView的位置
    self.imageView.width = self.width * 0.6;
    self.imageView.height = self.imageView.width;
    self.imageView.y = self.height * 0.1;
    self.imageView.centerX = self.width * 0.5;  // 设置垂直中心点
    
    // 设置textLabel属性
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

- (void)setHtml:(MMHTML *)html {
    
    _html = html;
    [self setTitle:html.name forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:html.icon] forState:UIControlStateNormal];
}

@end
