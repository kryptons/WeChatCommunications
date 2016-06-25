//
//  MMSettingGroup.h
//  MM
//
//  Created by 陈文昊 on 16/3/25.
//  Copyright © 2016年 NSObject. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMSettingItem.h"

@interface MMSettingGroup : NSObject

/** 组头部标题 */
@property (strong, nonatomic) NSString *headerTitle;

/** 组尾说明 */
@property (strong, nonatomic) NSString *footerTitle;

/** 组元素 */
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign, readonly) NSUInteger itemsCount;


- (id) initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle settingItems:(MMSettingItem *)firstObj, ...;


- (MMSettingItem *) itemAtIndex:(NSUInteger)index;
- (NSUInteger) indexOfItem:(MMSettingItem *)item;



@end
