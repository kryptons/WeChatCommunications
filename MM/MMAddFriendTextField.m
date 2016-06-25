//
//  MMAddFriendTextField.m
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import "MMAddFriendTextField.h"

@implementation MMAddFriendTextField

- (void)awakeFromNib {
    
    // 文本框光标颜色
    self.tintColor = MMTintColor;
    // 文字颜色
    self.textColor = MMboldColor;
    // 设置占位文字颜色
    [self resignFirstResponder];
}

#pragma mark - 设置占位文字颜色
/**
 *  文本框聚焦时调用(弹出当前文本框对应的键盘时调用)
 */
- (BOOL)becomeFirstResponder {
    
    [self setValue:MMboldColor forKeyPath:@"placeholderLabel.textColor"];
    return [super becomeFirstResponder];
}

/**
 *  文本框时区焦点时调用(隐藏当前文本框对应的键盘时调用)
 */
- (BOOL)resignFirstResponder {
    
    [self setValue:[UIColor grayColor] forKeyPath:@"placeholderLabel.textColor"];
    return [super resignFirstResponder];
}


@end
