//
//  MMHeaderFooterView.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHeaderFooterView : UITableViewHeaderFooterView

@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) UILabel *titleLabel;

+ (CGFloat)getHeightForText:(NSString *)text;

@end
