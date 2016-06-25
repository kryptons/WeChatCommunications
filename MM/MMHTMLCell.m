//
//  MMHTMLCell.m
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMHTMLCell.h"

@implementation MMHTMLCell

// cell的属性设置只需要设置一次时调用这个方法
// cell创建时使用循环标识时调用，不会进入init方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置cell的右边箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 设置cell里面字体颜色
        self.textLabel.textColor = [UIColor darkGrayColor];
    }
    return self;
}

// 设置cell里面图片跟textLabel的间距变小
- (void)layoutSubviews {
    
    [super layoutSubviews];
    // cell没有设置图片时直接返回
    if (self.imageView.image == nil) return;
    // 设置cell图片为固定的尺寸(正方形)
    self.imageView.y = 5;
    self.imageView.height = self.contentView.height - 2 * self.imageView.y;
    self.imageView.width = self.imageView.height;
    // 设置textLabel的x值变小点
    self.textLabel.x = CGRectGetMaxX(self.imageView.frame)+ 10;
}


@end
