//
//  MMHTMLButton.h
//  MM
//
//  Created by 陈文昊 on 16/3/27.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMHTML;
@interface MMHTMLButton : UIButton
/**
 * 模型数据
 */
@property (strong, nonatomic) MMHTML *html;

@end
