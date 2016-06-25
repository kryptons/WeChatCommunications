//
//  MMSettingCell.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMSettingItem.h"

@interface MMSettingCell : UITableViewCell

@property (strong, nonatomic) MMSettingItem *item;

+ (CGFloat)getHeightForText:(MMSettingItem *)item;

@end
